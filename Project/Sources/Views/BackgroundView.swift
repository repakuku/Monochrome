//
//  BackgroundView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
	@ObservedObject var gameManager: GameManager
	@Binding var showMenu: Bool

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.ignoresSafeArea()

			VStack {
				TopView(gameManager: gameManager, showMenu: $showMenu)
				Spacer()
				BottomView(gameManager: gameManager, showMenu: $showMenu)
			}
			.padding()
		}
	}
}

 struct TopView: View {
	@ObservedObject var gameManager: GameManager
	@Binding var showMenu: Bool
	@State private var guideViewIsShowing = false

	var body: some View {
		VStack {
			HStack {
				Button {
					withAnimation {
						gameManager.restartLevel()
						showMenu = false
					}
				} label: {
					RoundedImageView(systemName: Images.arrow.rawValue, isFilled: false)
				}
				Spacer()
				BigBoldText(text: "Level \(gameManager.levelId)")
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
						gameManager.getHint()
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
			GuideView(viewisShowing: $guideViewIsShowing)
		}
	}
 }

struct BottomView: View {
	@ObservedObject var gameManager: GameManager

	@State private var levelsViewIsShowing = false

	@Binding var showMenu: Bool

	var body: some View {
		HStack {
			RoundedTextView(text: String(gameManager.taps), isFilled: false)
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
			LevelsView(gameManager: gameManager, levelsViewIsShowing: $levelsViewIsShowing)
		}
	}
}

#Preview {
	BackgroundView(
		gameManager: GameManager(
			levelRepository: LevelRepository(),
			levelService: LevelService()
		),
		showMenu: .constant(true)
	)
}
