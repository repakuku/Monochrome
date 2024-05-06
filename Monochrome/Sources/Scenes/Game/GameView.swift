//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct GameView: View {
	@ObservedObject var viewModel: GameViewModel

	private let animation: Animation = .interactiveSpring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.5)

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.opacity(GameParameters.backgroundOpacity)
				.ignoresSafeArea()

			VStack(spacing: GameParameters.verticalStackSpacing) {
				MonochromeLabelView(color: Theme.mainColor)
				Spacer()
				FieldView(viewModel: viewModel)
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
	GameView(viewModel: GameViewModel())
}
