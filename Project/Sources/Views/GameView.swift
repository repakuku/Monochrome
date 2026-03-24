//
//  GameView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct GameView: View {
	@EnvironmentObject var viewModel: GameViewModel

	@State private var isMenuOpen = false
    @State private var activeOverlay: ActiveOverlay = .none

	var body: some View {
		ZStack {
			Theme.backgroundColor
				.ignoresSafeArea()

            if viewModel.isTutorialLevel {
				InstructionView()
                    .zIndex(2)
            } else {
                BackgroundView(
                    isMenuOpen: $isMenuOpen,
                    activeOverlay: $activeOverlay
                )
                .blur(radius: activeOverlay == .none ? Sizes.Blur.min : Sizes.Blur.max)
                .disabled(activeOverlay != .none)
            }

            FieldView(isMenuOpen: $isMenuOpen)
            .transition(.scale)
            .zIndex(1)
            .disabled(viewModel.isLevelCompleted || activeOverlay != .none)

            if activeOverlay == .result {
                ResultView()
                    .zIndex(3)
                    .transition(.scale)
            }

            if activeOverlay == .deleteConfirmation {
                DeleteGameView(activeOverlay: $activeOverlay)
                .zIndex(4)
                .transition(.scale)
            }
		}
		.onChange(
			of: viewModel.isLevelCompleted
		) { isCompleted in
			if isCompleted {
				DispatchQueue.main.asyncAfter(
					deadline: .now() + 0.6
				) {
					withAnimation {
						activeOverlay = .result
					}
				}
            } else if activeOverlay == .result {
				withAnimation {
                    activeOverlay = .none
				}
			}
		}
		.onTapGesture {
            isMenuOpen = false
		}
		.statusBarHidden()
		.navigationBarHidden(true)
	}
}

struct InstructionView: View {
	var body: some View {
		VStack {
			InstructionText(
                text: L10n.GameView.InstructionView.text
			)
			.padding(.bottom, Sizes.Padding.large)
		}
	}
}

#Preview {
    GameView()
        .environmentObject(
            GameViewModel(
                gameManager: GameManager(
                    gameRepository: GameRepository(),
                    levelService: LevelService(),
                    levelGenerator: LevelGenerator()
                )
            )
        )
}
