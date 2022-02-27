//
//  ComplexWidget.swift
//  PortfolioishWidgetExtension
//
//  Created by Deirdre Saoirse Moen on 2/26/22.
//

import WidgetKit
import SwiftUI
import Intents

struct PortfolioWidgetMultipleEntryView: View {
	@Environment(\.widgetFamily) var widgetFamily
	@Environment(\.sizeCategory) var sizeCategory

	let entry: Provider.Entry

	var items: ArraySlice<Item> {
		let itemCount: Int

		switch widgetFamily {
		case .systemSmall:
			itemCount = 1
		case .systemLarge:
			if sizeCategory < .extraExtraLarge {
				itemCount = 5
			} else {
				itemCount = 4
			}
		default:
			if sizeCategory < .extraLarge {
				itemCount = 3
			} else {
				itemCount = 2
			}
		}

		return entry.items.prefix(itemCount)
	}

	var body: some View {
		VStack(spacing: 5) {
			ForEach(items) { item in
				HStack {
					Color(item.project?.color ?? "Light Blue")
						.frame(width: 5)
						.clipShape(Capsule())

					VStack(alignment: .leading) {
						Text(item.itemTitle)
							.font(.headline)
							.layoutPriority(1)

						if let projectTitle = item.project?.projectTitle {
							Text(projectTitle)
								.foregroundColor(.secondary)
						}
					}

					Spacer()
				}
			}
		}
		.padding(20)
	}
}
struct ComplexPortfolioWidget: Widget {
	let kind: String = "ComplexPortfolioWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			PortfolioWidgetMultipleEntryView(entry: entry)
		}
		.configurationDisplayName("Up next…")
		.description("Your most important items.")
	}
}
