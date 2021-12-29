//
//  ProjectsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import SwiftUI

struct ProjectsView: View {
	let showClosedProjects: Bool
	let projects: FetchRequest<Project>

	init(showClosedProjects: Bool) {
		self.showClosedProjects = showClosedProjects

		projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.createdOn, ascending: false)],
			predicate: NSPredicate(format: "closed = %d", showClosedProjects))
	}

    var body: some View {
		NavigationView {
			List {
				ForEach(projects.wrappedValue) { project in
					Section(header: Text(project.title ?? "")) {
						ForEach(project.items?.allObjects as? [Item] ?? []) { item in
							Text(item.title ?? "")
						}
					}
				}
			}
#if os(macOS)
			.listStyle(.inset)
#else
			.listStyle(.insetGrouped)
#endif
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
		}
    }
}

struct ProjectsView_Previews: PreviewProvider {
	static var persistence = PersistenceController.preview

    static var previews: some View {
        ProjectsView(showClosedProjects: true)
			.environment(\.managedObjectContext, persistence.container.viewContext)
			.environmentObject(persistence)
    }
}
