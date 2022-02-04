//
//  EditItemView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import SwiftUI

struct EditItemView: View {
	@EnvironmentObject var persistence: Persistence
	let item: Item

	@State private var title: String
	@State private var detail: String
	@State private var priority: Int
	@State private var completed: Bool

	init(item: Item) {
		self.item = item

		_title = State(wrappedValue: item.itemTitle)
		_detail = State(wrappedValue: item.itemDetail)
		_priority = State(wrappedValue: Int(item.priority))
		_completed = State(wrappedValue: item.completed)
	}

	func update() {
		item.project?.objectWillChange.send()
		item.title = title
		item.detail = detail
		item.priority = Int16(priority)
		item.completed = completed
	}

    var body: some View {
		Form {
			Section(header: Text("Basic settings")) {
				TextField("Item name", text: $title.onChange(update))
				TextField("Description", text: $detail.onChange(update))
			}

			Section(header: Text("Priority")) {
				Picker("Priority", selection: $priority.onChange(update)) {
					Text("Low").tag(1)
					Text("Medium").tag(2)
					Text("High").tag(3)
				}
				.pickerStyle(SegmentedPickerStyle())
			}

			Section {
				Toggle("Mark Completed", isOn: $completed.onChange(update))
			}
		}
		.navigationTitle("Edit Item")
		.onDisappear(perform: persistence.save)
	}
}

struct ItemRowView: View {
	@ObservedObject var project: Project
	@ObservedObject var item: Item

	func icon() -> some View {
		if item.completed {
			return Image(systemName: "checkmark.circle")
				.foregroundColor(Color(project.projectColor))
		} else if item.priority == 3 {
			return Image(systemName: "exclamationmark.triangle.fill")
				.foregroundColor(Color(project.projectColor))
		} else if item.priority == 2 {
			return Image(systemName: "exclamationmark.triangle")
				.foregroundColor(Color(project.projectColor))
		} else {
			return Image(systemName: "checkmark.circle")
				.foregroundColor(.clear)
		}
	}

	var label: Text {
		if item.completed {
			return Text("\(item.itemTitle), completed.")
		} else if item.priority == 3 {
			return Text("\(item.itemTitle), high priority.")
		} else {
			return Text(item.itemTitle)
		}
	}

	var body: some View {
		NavigationLink(destination: EditItemView(item: item)) {
			Label(title: {
				Text(item.itemTitle)
			}, icon: icon)
			.accessibilityLabel(label)
		}
	}
}

struct EditItemView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
        EditItemView(item: Item.example)
			.environment(\.managedObjectContext, persistence.container.viewContext)
			.environmentObject(persistence)
    }
}

struct ItemRowView_Previews: PreviewProvider {
	static var previews: some View {
		ItemRowView(project: Project.example, item: Item.example)
	}
}
