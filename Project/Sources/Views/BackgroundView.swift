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
				Button {
					withAnimation {
						viewModel.restartLevel()
						showMenu = false
					}
				} label: {
					RoundedImageView(systemName: Images.arrow.rawValue, isFilled: false)
				}
				Spacer()
				BigBoldText(text: "Level \(viewModel.levelId)")
				Spacer()
				Button {
					withAnimation {
						showMenu.toggle()
					}
				} label: {
					RoundedImageView(systemName: Images.list.rawValue, isFilled: !showMenu)
				}
			}
			HStack {
				Spacer()
				Button {
					withAnimation {
						viewModel.getHint()
						showMenu.toggle()
					}
				} label: {
					if showMenu {
						RoundedImageView(systemName: Images.questionmark.rawValue, isFilled: false)
							.transition(.scale)
					}
				}
			}
			HStack {
				Spacer()
				Button {
					withAnimation {
						guideViewIsShowing = true
						showMenu.toggle()
					}
				} label: {
					if showMenu {
						RoundedImageView(systemName: Images.book.rawValue, isFilled: false)
							.transition(.scale)
					}
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
			RoundedTextView(text: String(viewModel.taps), isFilled: false)
			Spacer()
			Button {
				withAnimation {
					levelsViewIsShowing = true
					showMenu = false
				}
			} label: {
				RoundedImageView(systemName: Images.checklist.rawValue, isFilled: false)
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
