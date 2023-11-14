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
		VStack(spacing: Sizes.F.stackSpacing) {
			ForEach(0..<viewModel.fieldSize, id: \.self) { x in
				HStack(spacing: Sizes.F.stackSpacing) {
					ForEach(0..<viewModel.fieldSize, id: \.self) { y in
						let color = viewModel.getColorForCellAt(x: x, y: y)

						Color(color)
							.clipShape(
								RoundedRectangle(cornerSize: CGSize(width: Sizes.F.cornerRadius, height: Sizes.F.cornerRadius))
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
		.frame(width: Sizes.F.frameSize, height: Sizes.F.frameSize)
		.shadow(radius: Sizes.F.shadowRadius, x: Sizes.F.shadowOffset, y: Sizes.F.shadowOffset)
		.animation(.default, value: viewModel.fieldSize)
	}
}

#Preview {
	FieldView(viewModel: GameViewModell())
}
