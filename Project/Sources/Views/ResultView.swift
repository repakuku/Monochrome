//
//  ResultView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ResultView: View {
	@ObservedObject var gameManager: GameManager

	var body: some View {
		VStack {
			InstructionText(text: "Level completed!")
				.padding(.bottom)
			if gameManager.taps > 1 {
				BodyText(text: "You solved the level in \(gameManager.taps) taps.")
					.padding(.bottom)
			} else {
				BodyText(text: "You solved the level in \(gameManager.taps) tap.")
					.padding(.bottom)
			}
			HStack {
				if gameManager.level.id > 0 {
					Button {
						withAnimation {
							gameManager.restartLevel()
						}
					} label: {
						ButtonTextStroked(text: "Replay")
					}
				}
				Button {
					withAnimation {
						gameManager.nextLevel()
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
	ResultView(gameManager: GameManager())
}
