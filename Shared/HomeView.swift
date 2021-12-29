//
//  HomeView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var persistence: PersistenceController

	var body: some View {
		NavigationView {
			VStack {
				Button("Add Data") {
					persistence.deleteAll()
					try? persistence.createSampleData()
				}
			}
			.navigationTitle("Home")
		}
	}
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
