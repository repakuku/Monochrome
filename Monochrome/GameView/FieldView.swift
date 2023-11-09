//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/5/23.
//

import SwiftUI

struct FieldView: View {
	@ObservedObject var viewModel: GameViewModell

	private let stackSpacing = 2.0
	private let cornerRadius = 10
	private let frameSize = 350.0
	private let shadowRadius = 5.0
	private let shadowOffset = 20.0

	var body: some View {
		VStack(spacing: stackSpacing) {
			ForEach(0..<viewModel.size, id: \.self) { x in
				HStack(spacing: stackSpacing) {
					ForEach(0..<viewModel.size, id: \.self) { y in
						let color = viewModel.getColorForCellAt(x: x, y: y)

						Color(color)
							.clipShape(
								RoundedRectangle(cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
							)
							.onTapGesture {
								withAnimation {
									viewModel.changeColor(x: x, y: y)
									viewModel.checkGame()
								}
							}
					}
				}
			}
		}
		.frame(width: frameSize, height: frameSize)
		.shadow(radius: shadowRadius, x: shadowOffset, y: shadowOffset)
		.animation(.default, value: viewModel.size)
	}
}

#Preview {
	FieldView(viewModel: GameViewModell())
}
