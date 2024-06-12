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

	var body: some View {
		ZStack {
			BackgroundView(game: $game)
			if game.showInstructions {
				InstructionView()
					.transition(.offset(x: Sizes.Transition.largeOffset))
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
	}
}

struct InstructionView: View {
	var body: some View {
		VStack {
			InstructionText(text: "Tap on the cell...")
				.padding(.bottom, Sizes.Padding.large)
			InstructionText(text: "Target: Fill all the cells.")
		}
	}
}

#Preview {
	ContentView()
}
