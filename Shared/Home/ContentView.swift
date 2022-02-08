//
//  ContentView.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import SwiftUI

struct ContentView: View {
	@SceneStorage("selectedView") var selectedView: String?
	@EnvironmentObject var persistence: Persistence

    var body: some View {
		TabView(selection: $selectedView) {
			HomeView(persistence: persistence)
				.tabItem {
					Image(systemName: "house")
					Text("Home")
				}
				.tag(HomeView.tag)

			ProjectsView(persistence: persistence, showClosedProjects: false)
				.tag(ProjectsView.closedTag)
				.tabItem {
					Image(systemName: "list.bullet")
					Text("Open")
				}

			ProjectsView(persistence: persistence, showClosedProjects: true)
				.tag(ProjectsView.openTag)
				.tabItem {
					Image(systemName: "checkmark")
					Text("Closed")
				}

			AwardsView()
				.tag(AwardsView.tag)
				.tabItem {
					Image(systemName: "rosette")
					Text("Awards")
				}

			Text("Reset")
				.tag("Reset")
				.tabItem {
					Image(systemName: "trash.slash.fill")
					Text("Reset")
				}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
