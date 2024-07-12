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
	@State private var showInstruction = true
	@State private var showDeletionAlert = false

	var body: some View {
		ZStack {
			Theme.backgroundColor
				.ignoresSafeArea()

			if showInstruction {
				InstructionView()
			}

			if !viewModel.isTutorialLevel {
				BackgroundView(
					showFirstMenuItem: $showFirstMenuItem,
					showSecondMenuItem: $showSecondMenuItem,
					showInstruction: $showInstruction,
					showDeletionAlert: $showDeletionAlert
				)
				.blur(radius: (showResult || showDeletionAlert) ? Sizes.Blur.max : Sizes.Blur.min)
				.disabled((showResult || showDeletionAlert))
			}

			if showDeletionAlert {
				DeleteGameView(
					viewIsShowing: $showDeletionAlert,
					showInstruction: $showInstruction
				)
				.zIndex(2)
				.transition(.scale)
			} else if showResult {
				ResultView()
				.zIndex(1)
				.transition(.scale)
			} else {
				FieldView(
					showFirstMenuItem: $showFirstMenuItem,
					showSecondMenuItem: $showSecondMenuItem,
					showInstruction: $showInstruction
				)
				.transition(.scale)
				.zIndex(1)
				.disabled(viewModel.isLevelCompleted)
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
				text: "Tap on the cell"
			)
			.padding(.bottom, Sizes.Padding.large)
		}
	}
}

#Preview {
	GameView()
}
