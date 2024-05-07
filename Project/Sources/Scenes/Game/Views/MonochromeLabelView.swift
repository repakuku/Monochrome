//
//  MonochromeLabelView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct MonochromeLabelView: View {
	var body: some View {
		Text("Monochrome")
			.frame(width: 200, height: 50)
			.foregroundStyle(Color(Theme.mainColor))
			.font(.title)
			.overlay(
				RoundedRectangle(cornerRadius: GameParameters.NewGameButtonView.cornerRadius)
					.stroke(Color(Theme.mainColor), lineWidth: GameParameters.NewGameButtonView.lineWidth)
			)
	}
}

#Preview {
	MonochromeLabelView()
}
