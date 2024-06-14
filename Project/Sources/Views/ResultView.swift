//
//  ResultView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ResultView: View {
	@Binding var game: Game

	var body: some View {
		VStack {
			InstructionText(text: "Level completed!")
				.padding(.bottom)
			if game.steps > 1 {
				BodyText(text: "You solved the level for \(game.steps) taps.")
					.padding(.bottom)
			} else {
				BodyText(text: "You solved the level for \(game.steps) tap.")
					.padding(.bottom)
			}
			HStack {
				if game.level > 0 {
					Button {
						withAnimation {
							game.restart()
						}
					} label: {
						ButtonTextStroked(text: "Replay")
					}
				}
				Button {
					withAnimation {
						game.nextGame()
					}
				} label: {
					ButtonTextFilled(text: "Next Level")
				}
			}
		}
		.padding()
		.frame(width: 300)
		.background(
			Color(Theme.backgroundColor)
		)
		.clipShape(
			RoundedRectangle(cornerRadius: 20)
		)
		.shadow(radius: 10, x: 5, y: 5)
	}
}

#Preview {
	ResultView(game: .constant(Game()))
}
