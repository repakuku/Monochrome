//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct FieldView: View {
	@ObservedObject var viewModel: GameViewModel
	@Binding var showMenu: Bool
	@Binding var showInstruction: Bool

	var body: some View {
		VStack {
			ForEach(0..<viewModel.levelSize, id: \.self) { x in
				HStack {
					ForEach(0..<viewModel.levelSize, id: \.self) { y in
						Button {
							withAnimation {
								viewModel.cellTapped(atX: x, atY: y)
								if showMenu {
									showMenu = false
								}
								if showInstruction {
									showInstruction = false
								}
							}
						} label: {
							if viewModel.cells[x][y] == 0 {
								RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
									.stroke(lineWidth: Sizes.Stroke.width)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.accentCellColor)
									)
							} else if viewModel.cells[x][y] == 1 {
								RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
									.frame(
										width: Sizes.General.roundedViewLength,
										height: Sizes.General.roundedViewLength
									)
									.foregroundStyle(
										Color(Theme.accentCellColor)
									)
									.transition(.scale)
							} else if viewModel.cells[x][y] == 2 {
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
		viewModel: GameViewModel(
			gameManager: GameManager(
				gameRepository: GameRepository(
					levelRepository: LevelRepository(
						levelsJsonUrl: Endpoints.levelsJsonUrl
					)
				),
				levelRepository: LevelRepository(
					levelsJsonUrl: Endpoints.levelsJsonUrl
				),
				levelService: LevelService()
			)
		),
		showMenu: .constant(false),
		showInstruction: .constant(false)
	)
}
