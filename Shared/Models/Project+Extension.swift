//
//  Project+Extension.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import Foundation
import CoreData
import SwiftUI

extension Project {
	static let colors = ["Pink", "Purple", "Red", "Orange", "Gold",
		"Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]

	var projectTitle: String {
		title ?? NSLocalizedString("New Project", comment: "Create a new project")
	}

	var projectDetail: String {
		detail ?? ""
	}

	var projectColor: String {
		color ?? "Light Blue"
	}

	var label: LocalizedStringKey {
		// swiftlint:disable:next line_length
		LocalizedStringKey("\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete.")
	}

	static var example: Project {
		let controller = Persistence.preview
		let viewContext = controller.container.viewContext

		let project = Project(context: viewContext)
		project.title = "Example Project"
		project.detail = "This is an example project"
		project.closed = true
		project.createdOn = Date()
		return project
	}

	var completionAmount: Double {
		let originalItems = items?.allObjects as? [Item] ?? []
		guard originalItems.isEmpty == false else { return 0 }

		let completedItems = originalItems.filter(\.completed)
		return Double(completedItems.count) / Double(originalItems.count)
	}

	var projectItems: [Item] {
		items?.allObjects as? [Item] ?? []
	}

	var projectItemsDefaultSorted: [Item] {
		projectItems.sorted { first, second in
			if first.completed == false {
				if second.completed == true {
					return true
				}
			} else if first.completed == true {
				if second.completed == false {
					return false
				}
			}

			if first.priority > second.priority {
				return true
			} else if first.priority < second.priority {
				return false
			}

			return first.itemCreatedOn < second.itemCreatedOn
		}
	}

	func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
		switch sortOrder {
		case .title:
			let sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true)
			return self.projectItems.sorted(by: sortDescriptor)
		case .createdOn:
			let sortDescriptor = NSSortDescriptor(keyPath: \Item.createdOn, ascending: true)
			return self.projectItems.sorted(by: sortDescriptor)
		case .optimized:
			return projectItemsDefaultSorted
		}
	}
}
