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

	var body: some View {
		ZStack {
			Color(viewModel.backgroundColor)
				.opacity(0.6)
				.ignoresSafeArea()

			VStack(spacing: 30) {
				Text("Monochrome")
					.foregroundStyle(Color(viewModel.majorColor))
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
					.style(
						size: viewModel.size,
						limitSize: 2,
						majorColor: viewModel.majorColor,
						minorColor: viewModel.minorColor
					)

					Text("\(viewModel.size)x\(viewModel.size)")
						.font(.system(size: 80))
						.frame(width: 240)
						.foregroundStyle(Color(viewModel.majorColor))

					Button("+") {
						viewModel.increaseSize()
					}
					.style(
						size: viewModel.size,
						limitSize: 10,
						majorColor: viewModel.majorColor,
						minorColor: viewModel.minorColor
					)
				}
				.animation(.default, value: viewModel.size)

				Button("Start New Game") {
					withAnimation {
						viewModel.startNewGame()
					}
				}
				.frame(width: 300, height: 60)
				.foregroundStyle(Color(viewModel.majorColor))
				.font(.largeTitle)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color(viewModel.majorColor), lineWidth: 3)
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

struct CustomeStyle: ViewModifier {
	let size: Int
	let limitSize: Int
	let minorColor: String
	let majorColor: String

	func body(content: Content) -> some View {
		content
			.disabled(size == limitSize)
			.opacity(size == limitSize ? 0.4 : 1.0)
			.font(.system(size: 100))
			.foregroundStyle(size == 2 ? Color(minorColor) : Color(majorColor))
	}
}

extension Button {
	func style(
		size: Int,
		limitSize: Int,
		majorColor: String,
		minorColor: String
	) -> some View {
		modifier(
			CustomeStyle(
				size: size,
				limitSize: limitSize,
				minorColor: minorColor,
				majorColor: majorColor
			)
		)
	}
}
