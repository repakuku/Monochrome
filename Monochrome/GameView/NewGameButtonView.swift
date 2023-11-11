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
		.frame(width: 200, height: 60)
		.foregroundStyle(Color(viewModel.majorColor))
		.font(.largeTitle)
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color(viewModel.majorColor), lineWidth: 3)
		)
    }
}

#Preview {
    NewGameButtonView(viewModel: GameViewModell())
}
