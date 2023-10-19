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
		VStack(spacing: 2) {
			ForEach(0..<viewModel.size, id: \.self) { x in
				HStack(spacing: 2) {
					ForEach(0..<viewModel.size, id: \.self) { y in
						let color = viewModel.getColorForCellAt(x: x, y: y)

						Color(color)
							.clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
							.onTapGesture {
								viewModel.changeColor(x: x, y: y)
								viewModel.checkGame()
							}
					}
				}
			}
		}
		.frame(width: 350, height: 350)
	}
}

#Preview {
	FieldView(viewModel: GameViewModell())
}
