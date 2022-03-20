//
//  ProjectSummaryView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/3/22.
//

import SwiftUI
import StackNavigationView

struct ProjectSummaryView: View {
	@ObservedObject var project: Project

	var body: some View {
		StackNavigationLink(destination: EditProjectView(project: project)) {
			VStack(alignment: .leading) {
				Text("\(project.projectItems.count) items")
					.font(.caption)
					.foregroundColor(.secondary)

				ZStack {
					Text(project.projectTitle)
						.font(.title2)
						.foregroundColor(.primary)
					Text(project.projectTitle)
						.font(.title2)
						.foregroundColor(Color(project.projectColor))
						.opacity(0.5)
				}

				ProgressView(value: project.completionAmount)
					.accentColor(Color(project.projectColor))
			}
		}
		.padding()
		.background(Color.secondarySystemGroupedBackground)
		.cornerRadius(10)
		.shadow(color: Color.black.opacity(0.2), radius: 5)
		.accessibilityElement(children: .ignore)
		.accessibilityLabel(project.label)
	}
}

struct ProjectSummaryView_Previews: PreviewProvider {
	static var previews: some View {
		ProjectSummaryView(project: Project.example)
	}
}
