//
//  AwardsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/1/22.
//

import SwiftUI

struct AwardsView: View {
	@EnvironmentObject var persistence: PersistenceController

	@State private var selectedAward = Award.example
	@State private var showingAwardDetails = false

	static let tag: String? = "Awards"

	var columns: [GridItem] {
		[GridItem(.adaptive(minimum: 100, maximum: 100))]
	}
    var body: some View {
		NavigationView {
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(Award.allAwards) {
						award in
						Button {

						} label: {
							Image(systemName: award.image)
								.resizable()
								.scaledToFit()
								.padding()
								.frame(width: 100, height: 100)
								.foregroundColor(persistence.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5))
						}
						.accessibilityLabel(
							Text(persistence.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
						)
						.accessibilityHint(Text(award.description))
					}
				}
			}
			.navigationTitle("Awards")
		}
		.alert(isPresented: $showingAwardDetails) {
			if persistence.hasEarned(award: selectedAward) {
				return Alert(title: Text("Unlocked: \(selectedAward.name)"),
					message: Text("\(selectedAward.description)"),
					dismissButton: .default(Text("OK")))
			} else {
				return Alert(title: Text("Locked"),
					message: Text("\(selectedAward.description)"),
					dismissButton: .default(Text("OK")))
			}
		}
    }
}

struct AwardsView_Previews: PreviewProvider {
	static var persistence = PersistenceController.preview

    static var previews: some View {
        AwardsView()
			.environmentObject(persistence)
    }
}
