//
//  PlatformAdjustments.swift
//  Portfolioish (iOS)
//
//  Created by Deirdre Saoirse Moen on 3/2/22.
//

import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = EmptyView

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

extension Section where Parent: View, Content: View, Footer: View {
	func disableCollapsing() -> some View {
		self
	}
}

extension View {
	func onDeleteCommand(perform action: (() -> Void)?) -> some View {
		self
	}

	func macOnlyPadding() -> some View {
		self
	}
}
