//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/5/23.
//

import SwiftUI

struct FieldView: View {
	@ObservedObject var viewModel: GameViewModel

	let animation: Animation = .interactiveSpring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.5)

	var body: some View {
		VStack(spacing: GameParameters.FieldView.stackSpacing) {
			ForEach(0..<viewModel.fieldSize, id: \.self) { x in
				HStack(spacing: GameParameters.FieldView.stackSpacing) {
					ForEach(0..<viewModel.fieldSize, id: \.self) { y in
						Color(viewModel.getColorForCellAt(x: x, y: y))
							.clipShape(
								RoundedRectangle(cornerRadius: GameParameters.FieldView.cornerRadius)
							)
							.rotation3DEffect(
								.degrees(viewModel.game.field[x][y].isFlipped ? 0 : 180),
								axis: (x: 0, y: 1, z: 0)
							)
							.animation(animation.delay(Double(x + y) * 0.02), value: viewModel.fieldSize)
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
			radius: GameParameters.FieldView.shadowRadius
		)
	}
}

#Preview {
	FieldView(viewModel: GameViewModel())
}
