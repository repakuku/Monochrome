//
//  NewGameButtonView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct NewGameButtonView: View {
	@ObservedObject var viewModel: GameViewModell

    var body: some View {
		Button("New Game") {
			withAnimation {
				viewModel.startNewGame()
			}
		}
		.frame(width: GameSizes.NewGameButtonView.width, height: GameSizes.NewGameButtonView.height)
		.foregroundStyle(Color(viewModel.majorColor))
		.font(.largeTitle)
		.overlay(
			RoundedRectangle(cornerRadius: GameSizes.NewGameButtonView.cornerRadius)
				.stroke(Color(viewModel.majorColor), lineWidth: GameSizes.NewGameButtonView.lineWidth)
		)
    }
}

#Preview {
    NewGameButtonView(viewModel: GameViewModell())
}
