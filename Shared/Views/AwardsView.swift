//
//  AwardsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/1/22.
//

import SwiftUI

struct AwardsView: View {
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
								.foregroundColor(Color.secondary.opacity(0.5))
						}
					}
				}
			}
			.navigationTitle("Awards")
		}
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}