//
//  SizeView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct SizeView: View {
	@ObservedObject var viewModel: GameViewModell

    var body: some View {
		HStack(alignment: .center) {
			Button("-") {
				viewModel.decreaseSize()
			}
			.style(
				size: viewModel.fieldSize,
				limitSize: viewModel.minimumSize,
				majorColor: viewModel.majorColor,
				minorColor: viewModel.minorColor
			)

			Text("\(viewModel.fieldSize)x\(viewModel.fieldSize)")
				.font(.system(size: GameParameters.SizeView.textFontSize))
				.frame(width: GameParameters.SizeView.width)
				.foregroundStyle(Color(viewModel.majorColor))

			Button("+") {
				viewModel.increaseSize()
			}
			.style(
				size: viewModel.fieldSize,
				limitSize: viewModel.maximumSize,
				majorColor: viewModel.majorColor,
				minorColor: viewModel.minorColor
			)
		}
		.animation(.default, value: viewModel.fieldSize)
    }
}

#Preview {
    SizeView(viewModel: GameViewModell())
}

struct CustomeButtonStyle: ViewModifier {
	let size: Int
	let limitSize: Int
	let minorColor: String
	let majorColor: String

	func body(content: Content) -> some View {
		content
			.disabled(size == limitSize)
			.opacity(size == limitSize ? GameParameters.SizeView.minOpacity : GameParameters.SizeView.maxOpacity)
			.font(.system(size: GameParameters.SizeView.buttonFontSize))
			.foregroundStyle(size == limitSize ? Color(minorColor) : Color(majorColor))
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
			CustomeButtonStyle(
				size: size,
				limitSize: limitSize,
				minorColor: minorColor,
				majorColor: majorColor
			)
		)
	}
}
