//
//  BackgroundView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
	@EnvironmentObject var viewModel: GameViewModel

	@Binding var showFirstMenuItem: Bool
	@Binding var showSecondMenuItem: Bool
	@Binding var showInstruction: Bool
	@Binding var showDeletionAlert: Bool

	var body: some View {
		VStack {
			TopView(
				showFirstMenuItem: $showFirstMenuItem,
				showSecondMenuItem: $showSecondMenuItem
			)

			Spacer()

			BottomView(
				showFirstMenuItem: $showFirstMenuItem,
				showSecondMenuItem: $showSecondMenuItem,
				showInstruction: $showInstruction,
				showDeletionAlert: $showDeletionAlert
			)
		}
		.padding()
	}
}

struct TopView: View {
	@EnvironmentObject var viewModel: GameViewModel

	@Binding var showFirstMenuItem: Bool
	@Binding var showSecondMenuItem: Bool
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
						showFirstMenuItem = false
						showSecondMenuItem = false
					}
				}

				Spacer()

				BigBoldText(text: "Level \(viewModel.levelId)")

				Spacer()

				RoundedImageView(
					systemName: Images.list.rawValue,
					isFilled: showFirstMenuItem
				) {
					withAnimation {
						showFirstMenuItem.toggle()
					}
				}
			}
			.zIndex(2)

			if showFirstMenuItem {
				HStack {
					Spacer()

					VStack {
						RoundedImageView(
							systemName: Images.questionmark.rawValue,
							isFilled: false
						) {
							withAnimation {
								viewModel.getHint()
								showFirstMenuItem.toggle()
							}
						}
					}
				}
				.zIndex(1)
				.transition(.offset(y: -Sizes.General.roundedViewLength - Sizes.Spacing.small))
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
						withAnimation {
							showSecondMenuItem = true
						}
					}
				}
				.onDisappear {
					withAnimation {
						showSecondMenuItem = false
					}
				}
			}

			if showSecondMenuItem {
				HStack {
					Spacer()

					RoundedImageView(
						systemName: Images.book.rawValue,
						isFilled: false
					) {
						withAnimation {
							guideViewIsShowing = true
							showFirstMenuItem.toggle()
						}
					}
				}
				.zIndex(0)
				.transition(.offset(y: -Sizes.General.roundedViewLength - Sizes.Spacing.small))
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
	@EnvironmentObject var viewModel: GameViewModel

	@State private var levelsViewIsShowing = false
	@Binding var showFirstMenuItem: Bool
	@Binding var showSecondMenuItem: Bool
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
					showFirstMenuItem = false
					showSecondMenuItem = false
				}
			}
		}
		.sheet(isPresented: $levelsViewIsShowing) {
			LevelsView(
				levelsViewIsShowing: $levelsViewIsShowing,
				showInstruction: $showInstruction,
				showDeletionAlert: $showDeletionAlert
			)
		}
	}
}

#Preview {
	BackgroundView(
		showFirstMenuItem: .constant(true),
		showSecondMenuItem: .constant(true),
		showInstruction: .constant(false),
		showDeletionAlert: .constant(false)
	)
	.environmentObject(
		GameViewModel(
			gameManager: GameManager(
				gameRepository: GameRepository(),
				levelRepository: LevelRepository(),
				levelService: LevelService()
			)
		)
	)
}
