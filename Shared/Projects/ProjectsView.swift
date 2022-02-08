//
//  ProjectsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import CoreData
import SwiftUI

struct ProjectsView: View {

	@StateObject var viewModel: ViewModel
	@State private var showingSortOrder = false

	static let openTag: String? = "Open"
	static let closedTag: String? = "Closed"

    var body: some View {
		NavigationView {
			Group {
				if viewModel.projects.isEmpty {
					Text("There's nothing here right now.")
						.foregroundColor(.secondary)
				} else {
					projectsList
				}
			}
			.navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				addProjectToolbarItem
				sortOrderToolbarItem
			}
#if os(iOS)
			.actionSheet(isPresented: $showingSortOrder) {
				ActionSheet(title: Text("Sort items"), message: nil, buttons: [
					.default(Text("Optimized")) { viewModel.sortDescriptor = nil },
					.default(Text("Created On")) { viewModel.sortDescriptor =
						NSSortDescriptor(keyPath: \Item.createdOn, ascending: false) },
					.default(Text("Title")) { viewModel.sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true) }
				]) // ActionSheet
			} // .actionSheet
#endif
			SelectSomethingView()
		}
	}

	var projectsList: some View {
		List {
			ForEach(viewModel.projects) { project in
				Section(header: ProjectHeaderView(project: project)) {
					ForEach(viewModel.items(for: project)) { item in
						ItemRowView(project: project, item: item)
					}
					.onDelete { offsets in
						viewModel.delete(offsets, from: project)
					}

					if viewModel.showClosedProjects == false {
						Button {
							withAnimation {
								viewModel.addItem(to: project)
							}
						} label: {
							Label("Add New Item", systemImage: "plus")
						}
					}
				}
			}
		} // List
#if os(macOS)
		.listStyle(.inset)
#else
		.listStyle(.insetGrouped)
#endif
	}

	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			if viewModel.showClosedProjects == false {
				Button {
//					withAnimation {
						viewModel.addProject()
//					}
				} label: {

					// WORKAROUND: In iOS 14.3 VoiceOver has a glitch that reads the
					// label "Add Project" as "Add" no matter what accessibility label
					// we give this button when using a label. As a result, when
					// VoiceOver is running we use a text view for the button instead,
					// forcing a correct reading without losing the original layout.

					if UIAccessibility.isVoiceOverRunning {
						Text("Add Project")
					} else {
						Label("Add Project", systemImage: "plus")
					}
				}
			}
		}
	}

	var sortOrderToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button {
				viewModel.showingSortOrder.toggle()
			} label: {
				Label("Sort", systemImage: "arrow.up.arrow.down")
			}
		}
	}

	init(persistence: Persistence, showClosedProjects: Bool) {
		let viewModel = ViewModel(persistence: persistence, showClosedProjects: showClosedProjects)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
}

struct ProjectsView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
		ProjectsView(persistence: Persistence.preview, showClosedProjects: false)
			.environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
