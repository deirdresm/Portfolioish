//
//  ProjectsVM.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/11/22.
//

import CoreData
import Foundation
import SwiftUI

extension ProjectsView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		let persistence: Persistence

		var showingSortOrder = false
		var showClosedProjects: Bool

		private let projectsController: NSFetchedResultsController<Project>
		@Published var projects = [Project]()

		@State var sortDescriptor: NSSortDescriptor?

		init(persistence: Persistence, showClosedProjects: Bool) {
			self.persistence = persistence
			self.showClosedProjects = showClosedProjects

			let request: NSFetchRequest<Project> = Project.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.createdOn, ascending: false)]
			request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

			projectsController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)
			super.init()
			projectsController.delegate = self

			do {
				try projectsController.performFetch()
				projects = projectsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch projects")
			}
		}

		func addProject() {
			let project = Project(context: persistence.container.viewContext)

			project.closed = false
			project.createdOn = Date()
			print("adding project".debugDescription)
			persistence.save()
		}

		func addItem(to project: Project) {
				let item = Item(context: persistence.container.viewContext)
				item.project = project
				item.createdOn = Date()
				persistence.save()
		}

		func items(for project: Project) -> [Item] {
			guard let sortDescriptor = sortDescriptor else {
				return project.projectItemsDefaultSorted
			}
			return project.projectItems.sorted(by: sortDescriptor)
		}

		func delete(_ offsets: IndexSet, from project: Project) {
			let allItems = items(for: project)

			for offset in offsets {
				let item = allItems[offset]
				persistence.delete(item)
			}

			persistence.save()
		}

#if DEBUG
		func deleteAll() {
			persistence.deleteAll()
		}
#endif

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newProjects = controller.fetchedObjects as? [Project] {
				projects = newProjects
			}
		}
	}
}
