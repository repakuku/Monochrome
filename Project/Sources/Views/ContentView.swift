//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var game = Game()
	@State private var showMenu = false

	var body: some View {
		ZStack {
			if game.showInstructions {
				InstructionView()
			} else {
				BackgroundView(game: $game, showMenu: $showMenu)
					.opacity(game.gameCompleted ? 0.3 : 1)
					.disabled(game.gameCompleted)
			}

			if game.gameCompleted {
				ResultView(game: $game)
					.transition(.scale)
			} else {
				FieldView(game: $game)
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
