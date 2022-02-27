//
//  Provider.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/26/22.
//

import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
	let date: Date
	let items: [Item]
}

// swiftlint:disable vertical_parameter_alignment

struct Provider: IntentTimelineProvider, TimelineProvider {
	typealias Entry = SimpleEntry

	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), items: [Item.example])
	}

	func getSnapshot(for configuration: ConfigurationIntent,
					 in context: Context,
					 completion: @escaping (SimpleEntry) -> Void) {
		let entry = SimpleEntry(date: Date(), items: [Item.example])
		completion(entry)
	}

	func getTimeline(for configuration: ConfigurationIntent,
					 in context: Context,
					 completion: @escaping (Timeline<Entry>) -> Void) {
		let entry = SimpleEntry(date: Date(), items: loadItems())
		let timeline = Timeline(entries: [entry], policy: .never)
		completion(timeline)
	}

	func loadItems() -> [Item] {
		let persistence = Persistence()
		let itemRequest = persistence.fetchRequestForTopItems(count: 1)
		return persistence.results(for: itemRequest)
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
		let entry = SimpleEntry(date: Date(), items: loadItems())
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
		let entry = SimpleEntry(date: Date(), items: loadItems())
		let timeline = Timeline(entries: [entry], policy: .never)
		completion(timeline)
	}
}
