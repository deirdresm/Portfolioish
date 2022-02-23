//
//  SceneDelegate.swift
//  Portfolioish (iOS)
//
//  Created by Deirdre Saoirse Moen on 2/22/22.
//

import SwiftUI

///	SceneDelegate - support Quick Actions
class SceneDelegate: NSObject, UIWindowSceneDelegate {
	@Environment(\.openURL) var openURL

	func windowScene(
		_ windowScene: UIWindowScene,
		performActionFor shortcutItem: UIApplicationShortcutItem,
		completionHandler: @escaping (Bool) -> Void
	) {
		guard let url = URL(string: shortcutItem.type) else {
			completionHandler(false)
			return
		}

		openURL(url, completion: completionHandler)
	}

	/// scene - support Quick Actions on cold start
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		if let shortcutItem = connectionOptions.shortcutItem {
			guard let url = URL(string: shortcutItem.type) else {
				return
			}

			openURL(url)
		}
	}
}
