//
//  GameView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct GameView: View {
	@StateObject private var viewModel = GameViewModel(
		gameManager:
			GameManager(
				levelRepository: LevelRepository(),
				levelService: LevelService()
			)
	)

	@State private var showMenu = false
	@State private var showInstructions = true
	@State private var showResult = false

	var body: some View {
		ZStack {
			if showInstructions {
				InstructionView()
			}

			if !viewModel.isTutorialLevel {
				BackgroundView(
					viewModel: viewModel,
					showMenu: $showMenu
				)
					.blur(radius: viewModel.isLevelCompleted ? Sizes.Blur.max : Sizes.Blur.min)
					.disabled(viewModel.isLevelCompleted)
			}

			if showResult {
				ResultView(
					viewModel: viewModel
				)
					.transition(.scale)
			} else {
				FieldView(
					viewModel: viewModel,
					showInstructions: $showInstructions
				)
					.transition(.scale)
					.zIndex(1)
					.disabled(viewModel.isLevelCompleted)
			}
		}
		.onChange(of: viewModel.isLevelCompleted) { isCompleted in
			if isCompleted {
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
					withAnimation {
						showResult = true
					}
				}
			} else {
				withAnimation {
					showResult = false
				}
			}
		}
		.onTapGesture {
			withAnimation {
				showMenu = false
			}
		}
		.statusBarHidden()
	}
}

struct InstructionView: View {
	var body: some View {
		VStack {
			InstructionText(text: "Tap on the cell")
				.padding(.bottom, Sizes.Padding.large)
		}
	}
}

#Preview {
	GameView()
}
