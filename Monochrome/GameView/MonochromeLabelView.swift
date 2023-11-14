//
//  MonochromeLabelView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct MonochromeLabelView: View {
	let color: String

    var body: some View {
		Text("Monochrome")
			.foregroundStyle(Color(color))
			.font(.title)
    }
}

#Preview {
	MonochromeLabelView(color: GameColors.main.rawValue)
}
