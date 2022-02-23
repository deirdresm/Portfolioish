//
//  PurchaseButton.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/22/22.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
	 configuration.label
		 .frame(minWidth: 200, minHeight: 44)
		 .background(Color("Light Blue"))
		 .clipShape(Capsule())
		 .foregroundColor(.white)
		 .opacity(configuration.isPressed ? 0.5 : 1)
 }
}
