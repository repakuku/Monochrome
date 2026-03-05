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
                BodyText(text: L10n.GuideView.text)
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
					gameRepository: GameRepository(),
					levelRepository: LevelRepository(),
					levelService: LevelService()
				)
			),
		viewisShowing: .constant(true)
	)
}
