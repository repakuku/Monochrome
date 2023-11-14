//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/5/23.
//

import SwiftUI

struct FieldView: View {
	@ObservedObject var viewModel: GameViewModell

	let animation: Animation

	var body: some View {
		VStack(spacing: GameParameters.FieldView.stackSpacing) {
			ForEach(0..<viewModel.fieldSize, id: \.self) { x in
				HStack(spacing: GameParameters.FieldView.stackSpacing) {
					ForEach(0..<viewModel.fieldSize, id: \.self) { y in
						let color = viewModel.getColorForCellAt(x: x, y: y)

						Color(color)
							.clipShape(
								RoundedRectangle(
									cornerSize: CGSize(
										width: GameParameters.FieldView.cornerRadius,
										height: GameParameters.FieldView.cornerRadius
									)
								)
							)
							.onTapGesture {
								withAnimation(animation) {
									viewModel.changeColor(x: x, y: y)
								}
							}
					}
				}
			}
		}
		.frame(width: GameParameters.FieldView.frameSize, height: GameParameters.FieldView.frameSize)
		.shadow(
			radius: GameParameters.FieldView.shadowRadius,
			x: GameParameters.FieldView.shadowOffset,
			y: GameParameters.FieldView.shadowOffset
		)
		.animation(animation, value: viewModel.fieldSize)
	}
}

#Preview {
	FieldView(viewModel: GameViewModell(), animation: Animation.default)
}
