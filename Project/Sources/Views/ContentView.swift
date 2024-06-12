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
	@State private var alertIsVisible = false

	var body: some View {
		ZStack {
			BackgroundView(game: $game)
			if game.showInstructions {
				InstructionView()
					.transition(.offset(x: Sizes.Transition.largeOffset))
			}

			if alertIsVisible {
				ResultView(alertIsVisible: $alertIsVisible)
			} else {
				FieldView(game: $game)
			}
		}
	}
}

struct InstructionView: View {
	var body: some View {
		VStack {
			InstructionText(text: "Tap on any cell...")
				.padding(.bottom, Sizes.Padding.large)
			InstructionText(text: "Target: Fill all the cells.")
		}
	}
}

#Preview {
	ContentView()
}
