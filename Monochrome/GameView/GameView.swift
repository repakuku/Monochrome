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
			Color(viewModel.backgroundColor)
				.opacity(GameSizes.backgroundOpacity)
				.ignoresSafeArea()

			VStack(spacing: GameSizes.verticalStackSpacing) {
				MonochromeLabelView(color: viewModel.majorColor)
				Spacer()
				FieldView(viewModel: viewModel)
				Spacer()
				SizeView(viewModel: viewModel)
				NewGameButtonView(viewModel: viewModel)
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
