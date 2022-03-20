//
//  Persistence.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import CoreData
import CoreSpotlight
import SwiftUI
import WidgetKit

/// An environment singleton responsible for managing our Core Data stack,
/// including handling saving, counting fetch requests, tracking awards,
/// and dealing with sample data.

class Persistence: ObservableObject {
	/// The lone CloudKit container used to store all our data.
	let container: NSPersistentCloudKitContainer

	/// Address this class as a singleton (from anywhere).
	static let shared = Persistence()

	/// The UserDefaults suite where we're saving user data
	let defaults: UserDefaults

	static let preview: Persistence = {
		let previewController = Persistence(inMemory: true)
		let viewContext = previewController.container.viewContext

		do {
			try previewController.createSampleData()
		} catch {
			fatalError("Fatal error creating preview data.")
		}

		return previewController
	}()

	/// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
	/// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
	/// - Parameter inMemory: Whether to store this data in temporary memory or not.

	init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
		var isTesting = inMemory
		self.defaults = defaults

		container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

		// For testing and previewing purposes, we create a
		// temporary, in-memory database by writing to /dev/null
		// so preview/test data is destroyed after the app finishes running.

		if CommandLine.arguments.contains("enable-testing") {
			isTesting = true
		}

		if inMemory || isTesting {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		} else {
			let groupId = "group.net.deirdre.Portfolioish"

			if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) {
				container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
			}
		}

		if #available(iOS 13, macOS 10.15, *) {
			// Enable remote notifications
			guard let description = container.persistentStoreDescriptions.first else {
				fatalError("Failed to retrieve a persistent store description.")
			}
			description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		}

		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Fatal error loading store: \(error.localizedDescription)")
			}

			self.container.viewContext.automaticallyMergesChangesFromParent = true

			#if DEBUG
			if isTesting {
				self.deleteAll()
				#if os(iOS)
					UIView.setAnimationsEnabled(false)
				#endif
			}
			#endif
		}

		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.undoManager = nil
		container.viewContext.shouldDeleteInaccessibleFaults = true

//		if #available(iOS 13, macOS 10.15, *) {
//			// Observe Core Data remote change notifications.
//			NotificationCenter.default.addObserver(
//				self, selector: #selector(type(of: self).storeRemoteChange(_:)),
//				name: .NSPersistentStoreRemoteChange, object: nil)
//		}
	}

	func fetchRequestForTopItems(count: Int = 1) -> NSFetchRequest<Item> {
		let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

		let completedPredicate = NSPredicate(format: "completed = false")
		let openPredicate = NSPredicate(format: "project.closed = false")
		itemRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
		itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
		itemRequest.fetchLimit = count

		return itemRequest
	}

	func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
		return (try? container.viewContext.fetch(fetchRequest)) ?? []
	}

	/// Creates example projects and items to make manual testing easier.
	/// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.

	func createSampleData() throws {
		let viewContext = container.viewContext

		for projectCounter in 1...5 {
			let project = Project(context: viewContext)
			project.title = "Project \(projectCounter)"
			project.items = []
			project.createdOn = Date()
			project.closed = Bool.random()
			for itemCounter in 1...10 {
				let item = Item(context: viewContext)
				item.title = "Item \((projectCounter*10)+itemCounter)"
				item.createdOn = Date()
				item.completed = Bool.random()
				item.project = project
				item.priority = Int16.random(in: 1...3)
			}
		}
		try viewContext.save()
	}

	/// Deletes all existing data.
	/// Note: not called anywhere.

	func deleteAll() {
		let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
		delete(fetchRequest1)

		let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
		delete(fetchRequest2)

		container.viewContext.reset() // reset the container so the view refreshes to the new context container
	}

	/// Saves our Core Data context iff there are changes. This silently ignores
	/// any errors caused by saving, but this should be fine because all our
	/// attributes are optional. Also refreshes Widget timelines so they're fresh.
	func save() {
		if container.viewContext.hasChanges {
			try? container.viewContext.save()
			WidgetCenter.shared.reloadAllTimelines()
		}
	}

	func delete(_ object: NSManagedObject) {
		let id = object.objectID.uriRepresentation().absoluteString

		if object is Item {
			CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
		} else {
			CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
		}

		container.viewContext.delete(object)
	}

	private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
		let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		batchDeleteRequest1.resultType = .resultTypeObjectIDs

		if let delete = try? container.viewContext.execute(batchDeleteRequest1) as? NSBatchDeleteResult {
			let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
			NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
		}
	}

	func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
		(try? container.viewContext.count(for: fetchRequest)) ?? 0
	}

	/// addProject - create new project from a Quick Action or user action
	/// result is discardable because Quick Action will not use it.
	@discardableResult func addProject() -> Bool {
	   let canCreate = fullVersionUnlocked || count(for: Project.fetchRequest()) < 3

	   if canCreate {
		   let project = Project(context: container.viewContext)
		   project.closed = false
		   project.createdOn = Date()
		   save()
		   return true
	   } else {
		   return false
	   }
	}

	// Loads and saves whether our unlock has been purchased.
	var fullVersionUnlocked: Bool {
		get {
			defaults.bool(forKey: "fullVersionUnlocked")
		}

		set {
			defaults.set(newValue, forKey: "fullVersionUnlocked")
		}
	}

	/// Restore context after Spotlight search

	func item(with uniqueIdentifier: String) -> Item? {
		guard let url = URL(string: uniqueIdentifier) else {
			return nil
		}

		guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
			return nil
		}

		return try? container.viewContext.existingObject(with: id) as? Item
	}

	static let model: NSManagedObjectModel = {
		guard let url = Bundle.main.url(forResource: "Portfolioish", withExtension: "momd") else {
			fatalError("Failed to locate model file.")
		}

		guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
			fatalError("Failed to load model file.")
		}

		return managedObjectModel
	}()

	func update(_ item: Item) {
		let itemID = item.objectID.uriRepresentation().absoluteString
		let projectID = item.project?.objectID.uriRepresentation().absoluteString

		let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
		attributeSet.title = item.title
		attributeSet.contentDescription = item.detail.orEmpty

		let searchableItem = CSSearchableItem(uniqueIdentifier: itemID,
											  domainIdentifier: projectID,
											  attributeSet: attributeSet
		)

		CSSearchableIndex.default().indexSearchableItems([searchableItem])

		save()
	}
}
