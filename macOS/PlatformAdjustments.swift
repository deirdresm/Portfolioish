//
//  PlatformAdjustments.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 3/2/22.
//

import SwiftUI

typealias InsetGroupedListStyle = DefaultListStyle
typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = Spacer

extension Notification.Name {
	static let willResignActive = NSApplication.willResignActiveNotification
}

struct SimpleStackNavigationView<Content: View>: View {
	@ViewBuilder let content: () -> Content

	var body: some View {
		VStack(spacing: 0, content: content)
	}
}

extension Section where Parent : View, Content : View, Footer : View {
	public func disableCollapsing() -> some View {
		self.collapsible(false)
	}
}

extension View {
	func macOnlyPadding() -> some View {
		self.padding()
	}
}
