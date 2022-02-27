//
//  SimpleWidget.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/26/22.
//

import WidgetKit
import SwiftUI
import Intents

struct PortfolioishWidgetEntryView: View {
	var entry: Provider.Entry

	var body: some View {

		VStack {
			Text("Up next…")
				.font(.title)

			if let item = entry.items.first {
				Text(item.itemTitle)
			} else {
				Text("You're good!")
			}
		}
		.background(.orange)
	}
}

struct SimplePortfolioWidget: Widget {
	let kind: String = "SimplePortfolioWidget"

	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
			PortfolioishWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Up next…")
		.description("Your top-priority item.")
		.supportedFamilies([.systemSmall])
	}
}
