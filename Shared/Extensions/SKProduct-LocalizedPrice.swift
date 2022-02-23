//
//  SKProduct-LocalizedPrice.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/22/22.
//

import Foundation
import StoreKit

extension SKProduct {
	var localizedPrice: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = priceLocale
		return formatter.string(from: price)!
	}
}
