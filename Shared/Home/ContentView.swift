//
//  ContentView.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import SwiftUI
import CoreSpotlight

struct ContentView: View {
	@SceneStorage("selectedView") var selectedView: String?
	@EnvironmentObject var persistence: Persistence

	private let newProjectActivity = "net.deirdre.Portfolioish.newProject"

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

			SharedProjectsView()
				.tag(SharedProjectsView.tag)
				.tabItem {
					Image(systemName: "person.3")
					Text("Community")
				}

			Text("Reset")
				.tag("Reset")
				.tabItem {
					Image(systemName: "trash.slash.fill")
					Text("Reset")
				}
		}
		.onAppear(perform: persistence.appLaunched)
		.onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
		.onContinueUserActivity(newProjectActivity, perform: createProject)
		.userActivity(newProjectActivity) { activity in
			activity.title = "New Project"
			activity.isEligibleForPrediction = true
		}
		.onOpenURL(perform: openURL)
    }

	func moveToHome(_ input: Any) {
		selectedView = HomeView.tag
	}

	/// openURL: for opening from Quick Action
	func openURL(_ url: URL) {
		selectedView = ProjectsView.openTag
		_ = persistence.addProject()
	}

	/// createProject: for predictive shortcuts
	func createProject(_ userActivity: NSUserActivity) {
		selectedView = ProjectsView.openTag
		_ = persistence.addProject()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
		ContentView()
			.environmentObject(persistence)
	}
}
