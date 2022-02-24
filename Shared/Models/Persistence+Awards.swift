//
//  Persistence+Awards.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/23/22.
//

import CoreData

extension Persistence {
	func hasEarned(award: Award) -> Bool {
		switch award.criterion {
		case "items":
			// returns true if they added a certain number of items
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value
		case "complete":
			// returns true if they completed a certain number of items
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			fetchRequest.predicate = NSPredicate(format: "completed = true")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value
		default:
			// an unknown award criterion; this should never be allowed
//			fatalError("Unknown award criterion \(award.criterion).")
			return false
		}
	}
}
