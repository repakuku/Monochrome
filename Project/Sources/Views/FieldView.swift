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
								showMenu = false
								showInstruction = false
							}
						} label: {
							cellView(for: viewModel.cells[x][y])
						}
					}
				}
			}
		}
	}

	@ViewBuilder
	private func cellView(for value: CellState) -> some View {
		switch value {
		case .empty:
			CellView(filled: false, color: Color(Theme.accentCellColor))
		case .filled:
			CellView(filled: true, color: Color(Theme.accentCellColor))
		case .hintEmpty:
			CellView(filled: false, color: Color(Theme.hintCellColor))
		case .hintFilled:
			CellView(filled: true, color: Color(Theme.hintCellColor))
		}
	}
}

struct CellView: View {
	let filled: Bool
	let color: Color

	var body: some View {
		if filled {
			RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
				.frame(
					width: Sizes.General.roundedViewLength,
					height: Sizes.General.roundedViewLength
				)
				.foregroundStyle(color)
				.transition(.scale)
		} else {
			RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
				.stroke(lineWidth: Sizes.Stroke.width)
				.frame(
					width: Sizes.General.roundedViewLength,
					height: Sizes.General.roundedViewLength
				)
				.foregroundStyle(color)
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
