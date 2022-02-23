//
//  AppDelegate.swift
//  Portfolioish (iOS)
//
//  Created by Deirdre Saoirse Moen on 2/22/22.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
		sceneConfiguration.delegateClass = SceneDelegate.self
		return sceneConfiguration
	}
}
