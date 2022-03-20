//
//  PlatformAdjustments.swift
//  Portfolioish (iOS)
//
//  Created by Deirdre Saoirse Moen on 3/2/22.
//

import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
	static let willResignActive = UIApplication.willResignActiveNotification
}

struct SimpleStackNavigationView<Content: View>: View {
	@ViewBuilder let content: () -> Content

	var body: some View {
		NavigationView(content: content)
			.navigationViewStyle(.stack)
	}
}
