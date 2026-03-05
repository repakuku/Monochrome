//
//  MonochromeApp.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI
// import Firebase

@main
struct MonochromeApp: App {
	@StateObject private var viewModel = GameViewModel(
		gameManager: GameManager(
			gameRepository: GameRepository(),
			levelRepository: LevelRepository(),
			levelService: LevelService()
		)
	)

	init() {
		// TODO: Add dependencies fot Tuist
		// FirebaseApp.configure()
	}

	var body: some Scene {
		WindowGroup {
			WelcomeView()
				.environmentObject(viewModel)
		}
	}
}
