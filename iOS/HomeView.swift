//
//  HomeView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import CoreData
import CoreSpotlight
import SwiftUI
#if os(macOS)
	import StackNavigationView
#endif

struct HomeView: View {
	static let tag: String? = "Home"
	@StateObject var viewModel: ViewModel

	var projectRows: [GridItem] {
		[GridItem(.adaptive(minimum: 100, maximum: 100))]
	}

	init(persistence: Persistence) {
		let viewModel = ViewModel(persistence: persistence)
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		SimpleStackNavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					ScrollView(.horizontal, showsIndicators: false) {
						if let item = viewModel.selectedItem {
							NavigationLink(
								destination: EditItemView(item: item),
								tag: item,
								selection: $viewModel.selectedItem,
								label: EmptyView.init
							)
							.id(item)
						}

						LazyHGrid(rows: projectRows) {
							ForEach(viewModel.projects, content: ProjectSummaryView.init)
						}
					}
					.padding([.horizontal, .top])
					.fixedSize(horizontal: false, vertical: true)
				}

				VStack(alignment: .leading) {
					VStack(alignment: .leading) {
						ItemListView(title: "Up next", items: $viewModel.upNext)
						ItemListView(title: "More to explore", items: $viewModel.moreToExplore)
					}
				}
				.padding(.horizontal)
			}
			.onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
		}
		.background(Color.systemGroupedBackground.ignoresSafeArea())
		.navigationTitle("Home")
	}

	func loadSpotlightItem(_ userActivity: NSUserActivity) {
	   if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
		   viewModel.selectItem(with: uniqueIdentifier)
	   }
   }

	@ViewBuilder func list(_ title: LocalizedStringKey, for items: FetchedResults<Item>.SubSequence) -> some View {
		if items.isEmpty {
			EmptyView()
		} else {
			Text(title)
				.font(.headline)
				.foregroundColor(.secondary)
				.padding(.top)

			ForEach(items) { item in
				StackNavigationLink(destination: EditItemView(item: item)) {
					HStack(spacing: 20) {
						Circle()
							.stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
							.frame(width: 44, height: 44)
						VStack(alignment: .leading) {
							Text(item.itemTitle)
								.font(.title2)
								.foregroundColor(.primary)
								.frame(maxWidth: .infinity, alignment: .leading)

							if item.detail?.isEmpty == false {
								Text(item.detail.orEmpty)
									.foregroundColor(.secondary)
							}
						}
					}
					.padding()
					.background(Color.secondarySystemGroupedBackground)
					.cornerRadius(10)
					.shadow(color: Color.black.opacity(0.2), radius: 5)
				}
				.frame(minHeight: 44)
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
		HomeView(persistence: persistence)
    }
}
