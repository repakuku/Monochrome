//
//  MonochromeApp.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

@main
struct MonochromeApp: App {
    @StateObject private var viewModel = GameViewModel(
        gameManager: GameManager(
            gameRepository: GameRepository(),
            levelService: LevelService(),
            levelGenerator: LevelGenerator()
        )
    )

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(viewModel)
        }
    }
}
