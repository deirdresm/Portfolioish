//
//  Persistence+StoreKit.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/22/22.
//

import StoreKit

extension Persistence {
	// Loads and saves whether our unlock has been purchased.
	var fullVersionUnlocked: Bool {
		get {
			defaults.bool(forKey: "fullVersionUnlocked")
		}

		set {
			defaults.set(newValue, forKey: "fullVersionUnlocked")
		}
	}

	///	Encourage reviews
	func appLaunched() {
		let allScenes = UIApplication.shared.connectedScenes
		let scene = allScenes.first { $0.activationState == .foregroundActive }

		guard count(for: Project.fetchRequest()) >= 5 else { return }

		if let windowScene = scene as? UIWindowScene {
			SKStoreReviewController.requestReview(in: windowScene)
		}
	}
}
