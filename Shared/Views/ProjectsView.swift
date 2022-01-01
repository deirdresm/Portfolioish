//
//  ProjectsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import SwiftUI

struct ProjectsView: View {
	@EnvironmentObject var persistence: PersistenceController
	@Environment(\.managedObjectContext) var managedObjectContext

	static let openTag: String? = "Open"
	static let closedTag: String? = "Closed"

	@State private var showingSortOrder = false
	@State var sortDescriptor: NSSortDescriptor?

	let showClosedProjects: Bool
	let projects: FetchRequest<Project>

	init(showClosedProjects: Bool) {
		self.showClosedProjects = showClosedProjects

		projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.createdOn, ascending: false)],
			predicate: NSPredicate(format: "closed = %d", showClosedProjects))
	}

    var body: some View {
		NavigationView {
			Group {
				if projects.wrappedValue.isEmpty {
					Text("There's nothing here right now.")
						.foregroundColor(.secondary)
				} else {
					List {
						ForEach(projects.wrappedValue) { project in
							Section(header: ProjectHeaderView(project: project)) {
								ForEach(items(for: project)) { item in
									ItemRowView(project: project, item: item)
								}
								.onDelete { offsets in
									let allItems = items(for: project)

									for offset in offsets {
										let item = allItems[offset]
										persistence.delete(item)
									}

									persistence.save()
								}

								if showClosedProjects == false {
									Button {
										withAnimation {
											let item = Item(context: managedObjectContext)
											item.project = project
											item.createdOn = Date()
											persistence.save()
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
			}
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					if showClosedProjects == false {
						Button {
							withAnimation {
								let project = Project(context: managedObjectContext)
								project.closed = false
								project.createdOn = Date()
								persistence.save()
							}
						} label: {
							Label("Add Project", systemImage: "plus")
						}
					}
				} // ToolbarItem


				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						showingSortOrder.toggle()
					} label: {
						Label("Sort", systemImage: "arrow.up.arrow.down")
					}
				} // ToolbarItem
			} // .toolbar
#if os(iOS)
			.actionSheet(isPresented: $showingSortOrder) {
				ActionSheet(title: Text("Sort items"), message: nil, buttons: [
					.default(Text("Optimized")) { sortDescriptor = nil },
					.default(Text("Created On")) { sortDescriptor = NSSortDescriptor(keyPath: \Item.createdOn, ascending: false) },
					.default(Text("Title")) { sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true) }
				]) // ActionSheet
			} // .actionSheet
#endif
			SelectSomethingView()
		}
	}

	func items(for project: Project) -> [Item] {
		guard let sortDescriptor = sortDescriptor else {
			return project.projectItemsDefaultSorted
		}
		return project.projectItems.sorted(by: sortDescriptor)
	}
}

struct ProjectsView_Previews: PreviewProvider {
	static var persistence = PersistenceController.preview

    static var previews: some View {
        ProjectsView(showClosedProjects: false)
			.environment(\.managedObjectContext, persistence.container.viewContext)
			.environmentObject(persistence)
    }
}
