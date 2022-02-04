//
//  PortfolioishApp.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 12/28/21.
//

import SwiftUI

@main
struct PortfolioishApp: App {
	@StateObject var persistence: Persistence

	init() {
		let persistence = Persistence()
		_persistence = StateObject(wrappedValue: persistence)
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, persistence.container.viewContext)
				.environmentObject(persistence)

			// Automatically save when we detect that we are
			// no longer the foreground app. Use this rather than
			// scene phase so we can port to macOS, where scene
			// phase won't detect our app losing focus.
			
			#if os(macOS)
				.onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification), perform: save)
			#else

				.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
			#endif
        }
    }

	func save(_ note: Notification) {
		persistence.save()
	}
}
