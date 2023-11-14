//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct GameView: View {
	@ObservedObject var viewModel: GameViewModell

	private let animation = Animation.easeInOut(duration: 1)

	var body: some View {
		ZStack {
			Color(GameColors.background.rawValue)
				.opacity(GameParameters.backgroundOpacity)
				.ignoresSafeArea()

			VStack(spacing: GameParameters.verticalStackSpacing) {
				MonochromeLabelView(color: GameColors.main.rawValue)
				Spacer()
				FieldView(viewModel: viewModel, animation: animation)
				Spacer()
				SizeView(viewModel: viewModel, animation: animation)
				NewGameButtonView(viewModel: viewModel, animation: animation)
			}
		}
		.onAppear {
			withAnimation(animation) {
				viewModel.startNewGame()
			}
		}
		.alert("Complete!", isPresented: $viewModel.alertPresented) {
			Button("Start new game") {
				withAnimation(animation) {
					viewModel.startNewGame()
				}
			}
		}
	}
}

#Preview {
	GameView(viewModel: GameViewModell())
}
