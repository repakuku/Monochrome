//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var gameManager = GameManager(
		levelRepository: LevelRepository(),
		levelService: LevelService()
	)
	@State private var showMenu = false
	@State private var showInstructions = true

	var body: some View {
		ZStack {
			if showInstructions {
				InstructionView()
			} else {
				BackgroundView(gameManager: gameManager, showMenu: $showMenu)
					.opacity(gameManager.isLevelCompleted ? 0.3 : 1)
					.disabled(gameManager.isLevelCompleted)
			}

			if gameManager.isLevelCompleted {
				ResultView(gameManager: gameManager)
					.transition(.scale)
			} else {
				FieldView(gameManager: gameManager, showInstructions: $showInstructions)
					.zIndex(1)
					.transition(.scale)
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
	ContentView()
}
