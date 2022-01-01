//
//  ContentView.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import SwiftUI

struct ContentView: View {
	@SceneStorage("selectedView") var selectedView: String?

    var body: some View {
		TabView(selection: $selectedView) {
			HomeView()
				.tabItem {
					Image(systemName: "house")
					Text("Home")
				}
				.tag(HomeView.tag)

			ProjectsView(showClosedProjects: false)
				.tag(ProjectsView.closedTag)
				.tabItem {
					Image(systemName: "list.bullet")
					Text("Open")
				}

			ProjectsView(showClosedProjects: true)
				.tag(ProjectsView.openTag)
				.tabItem {
					Image(systemName: "checkmark")
					Text("Closed")
				}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
