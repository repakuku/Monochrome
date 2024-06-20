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
		VStack {
			TopView(gameManager: gameManager, showMenu: $showMenu)
			Spacer()
			BottomView(gameManager: gameManager)
		}
		.padding()
	}
}

struct TopView: View {
	@ObservedObject var gameManager: GameManager
	@Binding var showMenu: Bool

	@State private var levelsViewIsShowing = false

	var body: some View {
		VStack {
			HStack {
				Button {
					withAnimation {
						gameManager.restartLevel()
						showMenu = false
					}
				} label: {
					RoundedImageViewStroked(systemName: Images.arrow.description)
				}
				Spacer()
				Button {
					withAnimation {
						showMenu.toggle()
					}
				} label: {
					if showMenu {
						RoundedImageViewStroked(systemName: Images.list.description)
					} else {
						RoundedImageViewFilled(systemName: Images.list.description)
					}
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
						RoundedImageViewStroked(systemName: Images.questionmark.description)
							.transition(.scale)
					}
				}
			}
			HStack {
				Spacer()
				Button {
					withAnimation {
						levelsViewIsShowing = true
						showMenu.toggle()
					}
				} label: {
					if showMenu {
						RoundedImageViewStroked(systemName: Images.checklist.description)
							.transition(.scale)
					}
				}
				.sheet(isPresented: $levelsViewIsShowing) {
					LevelsView(gameManager: gameManager, levelsViewIsShowing: $levelsViewIsShowing)
				}
			}
		}
	}
}

struct BottomView: View {
	@ObservedObject var gameManager: GameManager

	var body: some View {
		HStack {
			NumberView(title: "Taps", text: String(gameManager.taps))
			Spacer()
			// TODO: gameManager.level.id -> gameManager.id
			NumberView(title: "Level", text: String(gameManager.level.id))
		}
	}
}

struct NumberView: View {
	let title: String
	let text: String

	var body: some View {
		HStack {
			VStack(spacing: Sizes.Spacing.normal) {
				LabelText(title: title)
				RoundedRectTextView(text: text)
			}
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
