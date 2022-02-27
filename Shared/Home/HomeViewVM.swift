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

		@Published var upNext = ArraySlice<Item>()
		@Published var moreToExplore = ArraySlice<Item>()

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
			let itemRequest = persistence.fetchRequestForTopItems(count: 10)

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

				upNext = items.prefix(3)
				moreToExplore = items.dropFirst(3)
			} catch {
				print("Failed to fetch initial data.")
			}
		}

		func selectItem(with identifier: String) {
			selectedItem = persistence.item(with: identifier)
		}

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			items = itemsController.fetchedObjects ?? []

			upNext = items.prefix(3)
			moreToExplore = items.dropFirst(3)

			projects = projectsController.fetchedObjects ?? []
		}

		func addSampleData() {
			persistence.deleteAll()
			try? persistence.createSampleData()
		}
	}

}
