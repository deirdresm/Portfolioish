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
	@StateObject var unlockManager: UnlockManager
	var isTesting: Bool

	#if os(iOS)
		@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	#endif

	init() {
		isTesting = false

		#if DEBUG
		if CommandLine.arguments.contains("enable-testing") {
			isTesting = true

			#if os(iOS)
			UIView.setAnimationsEnabled(false)
			#endif

			// Fake Sign In With Apple for simulator runs
			#if targetEnvironment(simulator)
			UserDefaults.standard.set("deirdre", forKey: "username")
			#endif
		}
		#endif

		let persistence = Persistence(inMemory: isTesting)
		_persistence = StateObject(wrappedValue: persistence)
		if isTesting {
			persistence.deleteAll()
		}

		let unlockManager = UnlockManager(persistence: persistence)
		_unlockManager = StateObject(wrappedValue: unlockManager)
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, persistence.container.viewContext)
				.environmentObject(persistence)
				.environmentObject(unlockManager)

			// Automatically save when we detect that we are
			// no longer the foreground app. Use this rather than
			// scene phase so we can port to macOS, where scene
			// phase won't detect our app losing focus.

			.onReceive(
				NotificationCenter.default.publisher(for: .willResignActive),
				perform: save
			)
        }
    }

	func save(_ note: Notification) {
		persistence.save()
	}
}
