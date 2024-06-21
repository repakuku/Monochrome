//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct FieldView: View {
	@ObservedObject var gameManager: GameManager
	@Binding var showInstructions: Bool

	var body: some View {
		VStack {
			ForEach(0..<gameManager.levelSize, id: \.self) { x in
				HStack {
					ForEach(0..<gameManager.levelSize, id: \.self) { y in
						Button {
							withAnimation {
								gameManager.toggleColors(atX: x, atY: y)
								showInstructions = false
							}
						} label: {
							if gameManager.level.cellsMatrix[x][y] == 0 {
								RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
									.stroke(lineWidth: Sizes.Stroke.width)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.accentCellColor)
									)
							} else if gameManager.level.cellsMatrix[x][y] == 1 {
								RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.accentCellColor)
									)
									.transition(.scale)
							} else if gameManager.level.cellsMatrix[x][y] == 2 {
								RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
									.stroke(lineWidth: Sizes.Stroke.width)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.hintCellColor)
									)
							} else {
								RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.hintCellColor)
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
	FieldView(
		gameManager: GameManager(
			levelRepository: LevelRepository(),
			levelService: LevelService()
		),
		showInstructions: .constant(true)
	)
}
