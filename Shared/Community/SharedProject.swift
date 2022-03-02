//
//  SharedProject.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 2/27/22.
//

import Foundation

struct SharedProject: Identifiable {
	let id: String
	let title: String
	let detail: String
	let owner: String
	let closed: Bool


	static let example = SharedProject(id: "1",
									   title: "Example",
									   detail: "Detail",
									   owner: "DeirdreSM",
									   closed: false)

}
