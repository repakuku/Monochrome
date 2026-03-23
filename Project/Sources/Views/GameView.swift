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

	@State private var showFirstMenuItem = false
	@State private var showSecondMenuItem = false
	@State private var showResult = false
//	@State private var showInstruction = true
	@State private var showDeletionAlert = false

	var body: some View {
		ZStack {
			Theme.backgroundColor
				.ignoresSafeArea()

            if viewModel.isTutorialLevel {
				InstructionView()
                    .zIndex(2)
            } else {
                BackgroundView(
                    showFirstMenuItem: $showFirstMenuItem,
                    showSecondMenuItem: $showSecondMenuItem,
                    showDeletionAlert: $showDeletionAlert
                )
                .blur(radius: (showResult || showDeletionAlert) ? Sizes.Blur.max : Sizes.Blur.min)
                .disabled((showResult || showDeletionAlert))
            }

            FieldView(
                showFirstMenuItem: $showFirstMenuItem,
                showSecondMenuItem: $showSecondMenuItem
            )
            .transition(.scale)
            .zIndex(1)
            .disabled(viewModel.isLevelCompleted || showResult || showDeletionAlert)

            if showResult {
                ResultView()
                    .zIndex(3)
                    .transition(.scale)
            }

            if showDeletionAlert {
                DeleteGameView(viewIsShowing: $showDeletionAlert)
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
				showFirstMenuItem = false
				showSecondMenuItem = false
			}
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
