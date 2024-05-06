//
//  NewGameButtonView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct NewGameButtonView: View {
	@ObservedObject var viewModel: GameViewModel

	let animation: Animation

	private let mainColor = Theme.mainColor

	var body: some View {
		Button("New Game") {
			withAnimation(animation) {
				viewModel.startNewGame()
			}
		}
		.frame(width: 200, height: 50)
		.foregroundStyle(Color(mainColor))
		.font(.title)
		.overlay(
			RoundedRectangle(cornerRadius: GameParameters.NewGameButtonView.cornerRadius)
				.stroke(Color(mainColor), lineWidth: GameParameters.NewGameButtonView.lineWidth)
		)
	}
}

#Preview {
	NewGameButtonView(viewModel: GameViewModel(), animation: .default)
}
