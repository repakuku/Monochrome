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
							RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
								.frame(
									width: Sizes.General.roundedViewLength,
									height: Sizes.General.roundedViewLength
								)
								.foregroundStyle(
									game.field[x][y] == 0 ? Color(Theme.mainCellColor) : Color(Theme.accentCellColor)
								)
								.transition(.slide)
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
