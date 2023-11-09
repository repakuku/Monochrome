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
				size: viewModel.size,
				limitSize: viewModel.minimumSize,
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
				limitSize: viewModel.maximumSize,
				majorColor: viewModel.majorColor,
				minorColor: viewModel.minorColor
			)
		}
		.animation(.default, value: viewModel.size)
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
			.opacity(size == limitSize ? 0.4 : 1.0)
			.font(.system(size: 100))
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
