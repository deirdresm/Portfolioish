//
//  ItemListView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/3/22.
//

import SwiftUI

struct ItemListView: View {
	let title: LocalizedStringKey
	@Binding var items: ArraySlice<Item>

    var body: some View {
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
			}
		}
    }
}

// struct ItemListView_Previews: PreviewProvider {
//	static var title: String = "Up next"
//	static var items: FetchedResults<Item>.SubSequence
//
//    static var previews: some View {
//		ItemListView(title: title, items: items.wrappedValue.prefix(3))
//    }
// }
