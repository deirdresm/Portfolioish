//
//  PlatformAdjustments.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 3/2/22.
//

import SwiftUI

typealias InsetGroupedListStyle = SidebarListStyle
typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
	static let willResignActive = NSApplication.willResignActiveNotification
}

struct SimpleStackNavigationView<Content: View>: View {
	@ViewBuilder let content: () -> Content

	var body: some View {
		VStack(spacing: 0, content: content)
	}
}
