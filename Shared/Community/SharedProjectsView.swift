//
//  SharedProjectsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/27/22.
//

import SwiftUI
import CloudKit

struct SharedProjectsView: View {
	static let tag: String? = "Community"

	@State private var projects = [SharedProject]()
	@State private var loadState = LoadState.inactive

	var body: some View {
		NavigationView {
			Group {
				switch loadState {
				case .inactive, .loading:
					ProgressView()
				case .noResults:
					Text("No results")
				case .success:
					List(projects) { project in
						NavigationLink(destination: SharedItemsView(project: project)) {
							VStack(alignment: .leading) {
								Text(project.title)
									.font(.headline)
								Text(project.owner)
							}
						}
					}
					.listStyle(InsetGroupedListStyle())
				}
			}
			.navigationTitle("Shared Projects")
		}
		.onAppear(perform: fetchSharedProjects)
	}

	func fetchSharedProjects() {
		guard loadState == .inactive else { return }
		loadState = .loading

		let pred = NSPredicate(value: true)
		let sort = NSSortDescriptor(key: "createdOn", ascending: false)
		let query = CKQuery(recordType: "Project", predicate: pred)
		query.sortDescriptors = [sort]

		let operation = CKQueryOperation(query: query)
		operation.desiredKeys = ["title", "detail", "owner", "closed"]
		operation.resultsLimit = 50
	}
}

struct SharedProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedProjectsView()
    }
}