//
//  SizeView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct SizeView: View {
	@ObservedObject var viewModel: GameViewModel

	let animation: Animation

	private let mainColor = GameColors.main.rawValue
	private let secondaryColor = GameColors.secondary.rawValue

    var body: some View {
		HStack(alignment: .center) {
			Button("-") {
				viewModel.decreaseSize()
			}
			.style(
				size: viewModel.fieldSize,
				limitSize: viewModel.minimumSize,
				mainColor: mainColor,
				secondaryColor: secondaryColor
			)

			Text("\(viewModel.fieldSize)x\(viewModel.fieldSize)")
				.font(.system(size: GameParameters.SizeView.textFontSize))
				.frame(width: GameParameters.SizeView.width)
				.foregroundStyle(Color(mainColor))

			Button("+") {
				viewModel.increaseSize()
			}
			.style(
				size: viewModel.fieldSize,
				limitSize: viewModel.maximumSize,
				mainColor: mainColor,
				secondaryColor: secondaryColor
			)
		}
		.animation(animation, value: viewModel.fieldSize)
    }
}

#Preview {
	SizeView(viewModel: GameViewModel(), animation: .default)
}

struct CustomeButtonStyle: ViewModifier {
	let size: Int
	let limitSize: Int
	let mainColor: String
	let secondaryColor: String

	func body(content: Content) -> some View {
		content
			.disabled(size == limitSize)
			.opacity(size == limitSize ? GameParameters.SizeView.minOpacity : GameParameters.SizeView.maxOpacity)
			.font(.system(size: GameParameters.SizeView.buttonFontSize))
			.foregroundStyle(size == limitSize ? Color(secondaryColor) : Color(mainColor))
	}
}

extension Button {
	func style(
		size: Int,
		limitSize: Int,
		mainColor: String,
		secondaryColor: String
	) -> some View {
		modifier(
			CustomeButtonStyle(
				size: size,
				limitSize: limitSize,
				mainColor: mainColor,
				secondaryColor: secondaryColor
			)
		)
	}
}
