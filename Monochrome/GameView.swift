//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct GameView: View {
	@StateObject private var viewModel = GameViewModell()

	private let minOpacity = 0.4
	private let maxOpacity = 1.0

	private let majorColor = "Major"
	private let minorColor = "Minor"
	private let backgroundColor = "Background"

	var body: some View {
		ZStack {
			Color(backgroundColor)
				.opacity(0.6)
				.ignoresSafeArea()

			VStack(spacing: 30) {
				Text("Monochrome")
					.foregroundStyle(Color(majorColor))
					.font(.title)

				Spacer()

				FieldView(viewModel: viewModel)
					.shadow(radius: 5, x: 20.0, y: 20.0)
					.animation(.default, value: viewModel.size)

				Spacer()

				HStack(alignment: .center) {
					Button("-") {
						viewModel.decreaseSize()
					}
					.disabled(viewModel.size == 2)
					.opacity(viewModel.size == 2 ? minOpacity : maxOpacity)
					.font(.system(size: 100))
					.foregroundStyle(viewModel.size == 2 ? Color(minorColor) : Color(majorColor))

					Text("\(viewModel.size)x\(viewModel.size)")
						.font(.system(size: 80))
						.frame(width: 240)
						.foregroundStyle(Color(majorColor))

					Button("+") {
						viewModel.increaseSize()
					}
					.disabled(viewModel.size == 10)
					.opacity(viewModel.size == 10 ? minOpacity : maxOpacity)
					.font(.system(size: 100))
					.foregroundStyle(viewModel.size == 10 ? Color(minorColor) : Color(majorColor))
				}
				.animation(.default, value: viewModel.size)

				Button("Start New Game") {
					withAnimation {
						viewModel.startNewGame()
					}
				}
				.frame(width: 300, height: 60)
				.foregroundStyle(Color(majorColor))
				.font(.largeTitle)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color(majorColor), lineWidth: 3)
				)
			}
		}
		.onAppear {
			withAnimation(Animation.easeInOut(duration: 1)) {
				viewModel.startNewGame()
			}
		}
		.alert("Complete!", isPresented: $viewModel.alertPresented) {
			Button("Start new game") {
				withAnimation {
					viewModel.startNewGame()
				}
			}
		}
	}
}

#Preview {
	GameView()
}
