//
//  PersistenceController.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import Foundation
import CoreData
import SwiftUI

class PersistenceController: ObservableObject {
	let container: NSPersistentCloudKitContainer
	static let shared = PersistenceController()

	static let preview: PersistenceController = {
		let previewController = PersistenceController(inMemory: true)
		let viewContext = previewController.container.viewContext

		do {
			try previewController.createSampleData()
		} catch {
			fatalError("Fatal error creating preview data.")
		}

		return previewController
	}()

	init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Portfolioish")
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		if #available(iOS 13, macOS 10.15, *) {
			// Enable remote notifications
			guard let description = container.persistentStoreDescriptions.first else {
				fatalError("Failed to retrieve a persistent store description.")
			}
			description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		}

		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Fatal error loading store \(error), \(error.userInfo)")
			}
		})

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

	func createSampleData() throws {
		let viewContext = container.viewContext

		for i in 1...5 {
			let project = Project(context: viewContext)
			project.title = "Project \(i)"
			project.items = []
			project.createdOn = Date()
			project.closed = Bool.random()
			for j in 1...10 {
				let item = Item(context: viewContext)
				item.title = "Item \((i*10)+j)"
				item.createdOn = Date()
				item.completed = Bool.random()
				item.project = project
				item.priority = Int16.random(in: 1...3)
			}
		}
		try viewContext.save()
	}

	func deleteAll() {
		let itemFetchRequest: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
		let itemBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: itemFetchRequest)
		_ = try? container.viewContext.execute(itemBatchDeleteRequest)

		let projectFetchRequest: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
		let projectBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: projectFetchRequest)
		_ = try? container.viewContext.execute(projectBatchDeleteRequest)
	}

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
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value
		case "complete":
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			fetchRequest.predicate = NSPredicate(format: "completed = true")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value
		default:
//			fatalError("Unknown award criterion \(award.criterion).")
			return false
		}
	}
}
