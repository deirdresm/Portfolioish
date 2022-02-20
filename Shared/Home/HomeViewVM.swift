//
//  HomeViewVM.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/3/22.
//

import Foundation
import CoreSpotlight
import CoreData

extension HomeView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		private let projectsController: NSFetchedResultsController<Project>
		private let itemsController: NSFetchedResultsController<Item>

		@Published var projects = [Project]()
		@Published var items = [Item]()
		@Published var selectedItem: Item?

		var upNext: ArraySlice<Item> {
			items.prefix(3)
		}

		var moreToExplore: ArraySlice<Item> {
			items.dropFirst(3)
		}

		var persistence: Persistence

		init(persistence: Persistence) {
			self.persistence = persistence
			// Construct a fetch request to show all open projects.
			let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
			projectRequest.predicate = NSPredicate(format: "closed = false")
			projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

			projectsController = NSFetchedResultsController(
				fetchRequest: projectRequest,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			// Construct a fetch request to show the 10 highest-priority,
			// incomplete items from open projects.
			let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

			let completedPredicate = NSPredicate(format: "completed = false")
			let openPredicate = NSPredicate(format: "project.closed = false")
			itemRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
			itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
			itemRequest.fetchLimit = 10

			itemsController = NSFetchedResultsController(
				fetchRequest: itemRequest,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			super.init()

			projectsController.delegate = self
			itemsController.delegate = self

			do {
				try projectsController.performFetch()
				try itemsController.performFetch()
				projects = projectsController.fetchedObjects ?? []
				items = itemsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch initial data.")
			}
		}

		func selectItem(with identifier: String) {
			selectedItem = persistence.item(with: identifier)
		}

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newItems = controller.fetchedObjects as? [Item] {
				items = newItems
			} else if let newProjects = controller.fetchedObjects as? [Project] {
				projects = newProjects
			}
		}

		func addSampleData() {
			persistence.deleteAll()
			try? persistence.createSampleData()
		}
	}

}
