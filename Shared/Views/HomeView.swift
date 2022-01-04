//
//  HomeView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import CoreData
import SwiftUI

struct HomeView: View {
	static let tag: String? = "Home"
	@EnvironmentObject var persistence: PersistenceController

	@FetchRequest(entity: Project.entity(),
				  sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
				  predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
	let items: FetchRequest<Item>

	var projectRows: [GridItem] {
		[GridItem(.adaptive(minimum: 100, maximum: 100))]
	}

	init() {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		request.predicate = NSPredicate(format: "completed = false")

		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \Item.priority, ascending: false)
		]

		request.fetchLimit = 10
		items = FetchRequest(fetchRequest: request)
	}

	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					ScrollView(.horizontal, showsIndicators: false) {
						LazyHGrid(rows: projectRows) {
							ForEach(projects) { project in
								VStack(alignment: .leading) {
									Text("\(project.projectItems.count) items")
										.font(.caption)
										.foregroundColor(.secondary)

									Text(project.projectTitle)
										.font(.title2)

									ProgressView(value: project.completionAmount)
										.accentColor(Color(project.projectColor))
								}
								.padding()
								.background(Color.secondarySystemGroupedBackground)
								.cornerRadius(10)
								.shadow(color: Color.black.opacity(0.2), radius: 5)
							}
						}
						.padding([.horizontal, .top])
						.fixedSize(horizontal: false, vertical: true)
					}

					VStack(alignment: .leading) {
						list("Up Next", for: items.wrappedValue.prefix(3))
						list("More to Explore", for: items.wrappedValue.dropFirst(3))
					}
					.padding(.horizontal)
				}
			}
			.background(Color.systemGroupedBackground.ignoresSafeArea())
			.navigationTitle("Home")
		}
	}

	@ViewBuilder func list(_ title: String, for items: FetchedResults<Item>.SubSequence) -> some View {
		if items.isEmpty {
			EmptyView()
		} else {
			Text(title)
				.font(.headline)
				.foregroundColor(.secondary)
				.padding(.top)

			ForEach(items) { item in
				NavigationLink(destination: EditItemView(item: item)) {
					HStack(spacing: 20) {
						Circle()
							.stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
							.frame(width: 44, height: 44)
						VStack(alignment: .leading) {
							Text(item.itemTitle)
								.font(.title2)
								.foregroundColor(.primary)
								.frame(maxWidth: .infinity, alignment: .leading)

							if item.itemDetail.isEmpty == false {
								Text(item.itemDetail)
									.foregroundColor(.secondary)
							}
						}
					}
					.padding()
					.background(Color.secondarySystemGroupedBackground)
					.cornerRadius(10)
					.shadow(color: Color.black.opacity(0.2), radius: 5)
				}
			}
		}
	}}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
