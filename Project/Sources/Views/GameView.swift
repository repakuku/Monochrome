//
//  GameView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct GameView: View {
	@StateObject private var gameManager = GameManager(
		levelRepository: LevelRepository(),
		levelService: LevelService()
	)
	@State private var showMenu = false
	@State private var showInstructions = true
	@State private var showResult = false

	var body: some View {
		ZStack {
			if showInstructions {
				InstructionView()
			} else {
				BackgroundView(gameManager: gameManager, showMenu: $showMenu)
					.opacity(gameManager.isLevelCompleted ? Sizes.Opacity.min : Sizes.Opacity.max)
					.disabled(gameManager.isLevelCompleted)
			}

			if showResult {
				ResultView(gameManager: gameManager)
					.transition(.scale)
			} else {
				FieldView(gameManager: gameManager, showInstructions: $showInstructions)
					.transition(.scale)
					.zIndex(1)
			}
		}
		.onChange(of: gameManager.isLevelCompleted) { isCompleted in
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
