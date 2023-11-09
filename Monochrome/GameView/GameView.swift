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
	private let backgroundOpacity = 0.6
	private let verticalStackSpaceing = 30.0

	var body: some View {
		ZStack {
			Color(viewModel.backgroundColor)
				.opacity(backgroundOpacity)
				.ignoresSafeArea()

			VStack(spacing: verticalStackSpaceing) {
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
