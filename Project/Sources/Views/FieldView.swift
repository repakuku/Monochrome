//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct FieldView: View {
	@Binding var game: Game

	var body: some View {
		VStack {
			ForEach(0..<game.fieldSize, id: \.self) { x in
				HStack {
					ForEach(0..<game.fieldSize, id: \.self) { y in
						Button {
							withAnimation {
								game.toggleColors(atX: x, atY: y)
							}
						} label: {
							if game.field.cells[x][y] == 0 {
								RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
									.stroke(lineWidth: Sizes.Stroke.width)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.accentCellColor)
									)
							} else {
								RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.accentCellColor)
									)
									.transition(.scale)
							}
						}
					}
				}
			}
		}
	}
}

#Preview {
	FieldView(game: .constant(Game()))
}
