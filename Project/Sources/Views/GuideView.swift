//
//  GuideView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/21/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct GuideView: View {
	@ObservedObject var viewModel: GameViewModel
	@Binding var viewisShowing: Bool

	var body: some View {
		ZStack {
			Theme.backgroundColor
				.ignoresSafeArea()
			VStack {
				GuideHeaderView(
					viewModel: viewModel,
					viewIsShowing: $viewisShowing
				)
				Spacer()
				BodyText(text: "In Monochrome, your goal is to make all cells the same color by tapping to flip their colors. Each tap affects the selected cell and its row and column. Solve each puzzle with the fewest taps. \n\nGood luck!") // swiftlint:disable:this line_length
					.frame(width: 300)
					.padding()
				Spacer()
			}
		}
	}
}

struct GuideHeaderView: View {
	@ObservedObject var viewModel: GameViewModel
	@Binding var viewIsShowing: Bool

	var body: some View {
		ZStack {
			HStack {
				Spacer()
				RoundedImageView(
					systemName: Images.xmark.rawValue,
					isFilled: false
				) {
					withAnimation {
						viewIsShowing = false
					}
				}
			}
		}
		.padding()
	}
}

#Preview {
	GuideView(
		viewModel: GameViewModel(
			gameManager: GameManager(
				gameRepository: GameRepository(
					levelRepository: LevelRepository()
				),
				levelService: LevelService()
			)
		),
		viewisShowing: .constant(true)
	)
}
