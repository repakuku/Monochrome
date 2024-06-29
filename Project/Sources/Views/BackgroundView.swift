//
//  BackgroundView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
	@ObservedObject var viewModel: GameViewModel
	@Binding var showMenu: Bool
	@Binding var showInstruction: Bool
	@Binding var showDeletionAlert: Bool

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.ignoresSafeArea()

			VStack {
				TopView(viewModel: viewModel, showMenu: $showMenu)
				Spacer()
				BottomView(
					viewModel: viewModel,
					showMenu: $showMenu,
					showInstruction: $showInstruction,
					showDeletionAlert: $showDeletionAlert
				)
			}
			.padding()
		}
	}
}

struct TopView: View {
	@ObservedObject var viewModel: GameViewModel

	@Binding var showMenu: Bool
	@State private var guideViewIsShowing = false

	var body: some View {
		VStack {
			HStack {
				RoundedImageView(
					systemName: Images.arrow.rawValue,
					isFilled: false
				) {
					withAnimation {
						viewModel.restartLevel()
						showMenu = false
					}
				}

				Spacer()

				BigBoldText(text: "Level \(viewModel.levelId)")

				Spacer()

				RoundedImageView(
					systemName: Images.list.rawValue,
					isFilled: !showMenu
				) {
					withAnimation {
						showMenu.toggle()
					}
				}
			}

			HStack {
				Spacer()

				if showMenu {
					RoundedImageView(
						systemName: Images.questionmark.rawValue,
						isFilled: false
					) {
						withAnimation {
							viewModel.getHint()
							showMenu.toggle()
						}
					}
					.transition(.scale)
				}
			}

			HStack {
				Spacer()

				if showMenu {
					RoundedImageView(
						systemName: Images.book.rawValue,
						isFilled: false
					) {
						withAnimation {
							guideViewIsShowing = true
							showMenu.toggle()
						}
					}
					.transition(.scale)
				}
			}
		}
		.sheet(isPresented: $guideViewIsShowing) {
			GuideView(
				viewModel: viewModel,
				viewisShowing: $guideViewIsShowing
			)
		}
	}
}

struct BottomView: View {
	@ObservedObject var viewModel: GameViewModel
	@State private var levelsViewIsShowing = false
	@Binding var showMenu: Bool
	@Binding var showInstruction: Bool
	@Binding var showDeletionAlert: Bool

	var body: some View {
		HStack {
			RoundedImageView(
				systemName: Images.back.rawValue,
				isFilled: false
			) {
				withAnimation {
					viewModel.undoButtonTapped()
				}
			}

			Spacer()

			TapsView(taps: $viewModel.taps)

			Spacer()

			RoundedImageView(
				systemName: Images.checklist.rawValue,
				isFilled: false
			) {
				withAnimation {
					levelsViewIsShowing = true
					showMenu = false
				}
			}
		}
		.sheet(isPresented: $levelsViewIsShowing) {
			LevelsView(
				viewModel: viewModel,
				levelsViewIsShowing: $levelsViewIsShowing,
				showInstruction: $showInstruction,
				showDeletionAlert: $showDeletionAlert
			)
		}
	}
}

#Preview {
	BackgroundView(
		viewModel: GameViewModel(
			gameManager: GameManager(
				gameRepository: GameRepository(
					levelRepository: LevelRepository(
						levelsJsonUrl: Endpoints.levelsJsonUrl
					)
				),
				levelRepository: LevelRepository(
					levelsJsonUrl: Endpoints.levelsJsonUrl
				),
				levelService: LevelService()
			)
		),
		showMenu: .constant(true),
		showInstruction: .constant(false),
		showDeletionAlert: .constant(false)
	)
}
