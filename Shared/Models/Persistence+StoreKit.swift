//
//  Persistence+StoreKit.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/22/22.
//

import StoreKit

extension Persistence {
	///	Encourage reviews
	func appLaunched() {
		// swiftlint:disable:next todo
		// TODO: nudge for app reviews in macOS
		#if os(iOS)
			let allScenes = UIApplication.shared.connectedScenes

			let scene = allScenes.first { $0.activationState == .foregroundActive }

			guard count(for: Project.fetchRequest()) >= 5 else { return }

			if let windowScene = scene as? UIWindowScene {
				SKStoreReviewController.requestReview(in: windowScene)
			}
		#endif
	}
}
