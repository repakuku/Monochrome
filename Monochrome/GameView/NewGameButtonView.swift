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
		.frame(width: GameParameters.NewGameButtonView.width, height: GameParameters.NewGameButtonView.height)
		.foregroundStyle(Color(viewModel.majorColor))
		.font(.largeTitle)
		.overlay(
			RoundedRectangle(cornerRadius: GameParameters.NewGameButtonView.cornerRadius)
				.stroke(Color(viewModel.majorColor), lineWidth: GameParameters.NewGameButtonView.lineWidth)
		)
    }
}

#Preview {
    NewGameButtonView(viewModel: GameViewModell())
}
