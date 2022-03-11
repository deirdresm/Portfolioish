//
//  CloudError.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 3/10/22.
//

import Foundation
import SwiftUI

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
	var id: String { message }
	var message: String

	init(stringLiteral value: String) {
		self.message = value
	}

	var localizedMessage: LocalizedStringKey {
		LocalizedStringKey(message)
	}
}
