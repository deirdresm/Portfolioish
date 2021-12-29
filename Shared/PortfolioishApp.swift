//
//  PortfolioishApp.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import SwiftUI

@main
struct PortfolioishApp: App {
	@StateObject var persistence: PersistenceController

	init() {
		let persistence = PersistenceController()
		_persistence = StateObject(wrappedValue: persistence)
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, persistence.container.viewContext)
				.environmentObject(persistence)
        }
    }
}
