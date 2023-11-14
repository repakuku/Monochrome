//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/5/23.
//

import SwiftUI

struct FieldView: View {
	@ObservedObject var viewModel: GameViewModell

	var body: some View {
		VStack(spacing: GameSizes.FieldView.stackSpacing) {
			ForEach(0..<viewModel.fieldSize, id: \.self) { x in
				HStack(spacing: GameSizes.FieldView.stackSpacing) {
					ForEach(0..<viewModel.fieldSize, id: \.self) { y in
						let color = viewModel.getColorForCellAt(x: x, y: y)

						Color(color)
							.clipShape(
								RoundedRectangle(
									cornerSize: CGSize(
										width: GameSizes.FieldView.cornerRadius,
										height: GameSizes.FieldView.cornerRadius
									)
								)
							)
							.onTapGesture {
								withAnimation {
									viewModel.changeColor(x: x, y: y)
								}
							}
					}
				}
			}
		}
		.frame(width: GameSizes.FieldView.frameSize, height: GameSizes.FieldView.frameSize)
		.shadow(
			radius: GameSizes.FieldView.shadowRadius,
			x: GameSizes.FieldView.shadowOffset,
			y: GameSizes.FieldView.shadowOffset
		)
		.animation(.default, value: viewModel.fieldSize)
	}
}

#Preview {
	FieldView(viewModel: GameViewModell())
}
