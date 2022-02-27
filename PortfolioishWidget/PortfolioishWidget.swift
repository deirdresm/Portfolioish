//
//  PortfolioishWidget.swift
//  PortfolioishWidget
//
//  Created by Deirdre Saoirse Moen on 2/23/22.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct PortfolioishWidgets: WidgetBundle {
	var body: some Widget {
		SimplePortfolioWidget()
		ComplexPortfolioWidget()
	}
}

struct PortfolioishWidget_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioishWidgetEntryView(entry: SimpleEntry(date: Date(),
									items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
