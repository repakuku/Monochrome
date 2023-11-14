//
//  NewGameButtonView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct NewGameButtonView: View {
	@ObservedObject var viewModel: GameViewModell

	let animation: Animation

	private let mainColor = GameColors.main.rawValue

    var body: some View {
		Button("New Game") {
			withAnimation(animation) {
				viewModel.startNewGame()
			}
		}
		.frame(width: GameParameters.NewGameButtonView.width, height: GameParameters.NewGameButtonView.height)
		.foregroundStyle(Color(mainColor))
		.font(.largeTitle)
		.overlay(
			RoundedRectangle(cornerRadius: GameParameters.NewGameButtonView.cornerRadius)
				.stroke(Color(mainColor), lineWidth: GameParameters.NewGameButtonView.lineWidth)
		)
    }
}

#Preview {
	NewGameButtonView(viewModel: GameViewModell(), animation: .default)
}
