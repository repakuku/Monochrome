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

	private let mainColor = Theme.mainColor
	private let accentColor = Theme.accentColor

    var body: some View {
		HStack(alignment: .center) {
			Button("-") {
				viewModel.decreaseSize()
			}
			.style(
				size: viewModel.fieldSize,
				limitSize: viewModel.minimumSize,
				mainColor: mainColor,
				accentColor: accentColor
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
				accentColor: accentColor
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
	let mainColor: UIColor
	let accentColor: UIColor

	func body(content: Content) -> some View {
		content
			.disabled(size == limitSize)
			.opacity(size == limitSize ? GameParameters.SizeView.minOpacity : GameParameters.SizeView.maxOpacity)
			.font(.system(size: GameParameters.SizeView.buttonFontSize))
			.foregroundStyle(size == limitSize ? Color(accentColor) : Color(mainColor))
	}
}

extension Button {
	func style(
		size: Int,
		limitSize: Int,
		mainColor: UIColor,
		accentColor: UIColor
	) -> some View {
		modifier(
			CustomeButtonStyle(
				size: size,
				limitSize: limitSize,
				mainColor: mainColor,
				accentColor: accentColor
			)
		)
	}
}
