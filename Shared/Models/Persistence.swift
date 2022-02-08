//
//  Persistence.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import Foundation
import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack,
/// including handling saving, counting fetch requests, tracking awards,
/// and dealing with sample data.

class Persistence: ObservableObject {
	/// The lone CloudKit container used to store all our data.
	let container: NSPersistentCloudKitContainer

	/// Address this class as a singleton (from anywhere).
	static let shared = Persistence()

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

	init(inMemory: Bool = false) {
		var isTesting = inMemory
		container = NSPersistentCloudKitContainer(name: "Portfolioish", managedObjectModel: Self.model)

		// For testing and previewing purposes, we create a
		// temporary, in-memory database by writing to /dev/null
		// so preview/test data is destroyed after the app finishes running.

		if CommandLine.arguments.contains("enable-testing") {
			isTesting = true
		}

		if inMemory || isTesting {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
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

			#if DEBUG
			if isTesting {
				self.deleteAll()
				UIView.setAnimationsEnabled(false)
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
		let itemFetchRequest: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
		let itemBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: itemFetchRequest)
		_ = try? container.viewContext.execute(itemBatchDeleteRequest)

		let projectFetchRequest: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
		let projectBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: projectFetchRequest)
		_ = try? container.viewContext.execute(projectBatchDeleteRequest)

		container.viewContext.reset() // reset the container so the view refreshes to the new context container
//		try? container.viewContext.save()
	}

	/// Saves our Core Data context iff there are changes. This silently ignores
	/// any errors caused by saving, but this should be fine because all our
	/// attributes are optional.

	func save() {
		if container.viewContext.hasChanges {
			try? container.viewContext.save()
		}
	}

	func delete(_ object: NSManagedObject) {
		container.viewContext.delete(object)
	}

	func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
		(try? container.viewContext.count(for: fetchRequest)) ?? 0
	}

	func hasEarned(award: Award) -> Bool {
		switch award.criterion {
		case "items":
			// returns true if they added a certain number of items
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value
		case "complete":
			// returns true if they completed a certain number of items
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			fetchRequest.predicate = NSPredicate(format: "completed = true")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value
		default:
			// an unknown award criterion; this should never be allowed
//			fatalError("Unknown award criterion \(award.criterion).")
			return false
		}
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
}
