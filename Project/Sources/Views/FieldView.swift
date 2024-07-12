//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct FieldView: View {
	@EnvironmentObject var viewModel: GameViewModel

	@Binding var showFirstMenuItem: Bool
	@Binding var showSecondMenuItem: Bool
	@Binding var showInstruction: Bool

	var body: some View {
		VStack {
			ForEach(0..<viewModel.levelSize, id: \.self) { x in
				HStack {
					ForEach(0..<viewModel.levelSize, id: \.self) { y in
						cellView(for: viewModel.cells[x][y]) {
							withAnimation {
								viewModel.cellTapped(atX: x, atY: y)
								showFirstMenuItem = false
								showSecondMenuItem = false
								showInstruction = false
							}
						}
					}
				}
			}
		}
	}

	@ViewBuilder
	private func cellView(for value: CellState, action: @escaping () -> Void) -> some View {
		RoundedCellView(
			color: color(for: value),
			isFilled: isFilled(for: value),
			action: action
		)
	}

	private func color(for value: CellState) -> Color {
		switch value {
		case .empty, .filled:
			return Theme.foregroundColor
		case .hintEmpty, .hintFilled:
			return Theme.accentColor
		}
	}

	private func isFilled(for value: CellState) -> Bool {
		switch value {
		case .empty, .hintEmpty:
			return false
		case .filled, .hintFilled:
			return true
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
		showFirstMenuItem: .constant(false),
		showSecondMenuItem: .constant(false),
		showInstruction: .constant(false)
	)
	.environmentObject(
		GameViewModel(
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
		)
	)
}
