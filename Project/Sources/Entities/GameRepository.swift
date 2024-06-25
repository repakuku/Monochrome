//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class GameRepository {

	private var game: Game

	init(game: Game) {
		self.game = game
	}

	func getGame() -> Game {
		game
	}

	private func saveGame(_ game: Game, to gameUrl: URL) {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		do {
			let gameData = try encoder.encode(game)
			try gameData.write(to: gameUrl, options: .atomic)
		} catch {
		}
	}

	private func loadGame(from gameUrl: URL) {
		let decoder = JSONDecoder()

		do {
			let gameData = try Data(contentsOf: gameUrl)
			let game = try decoder.decode(Game.self, from: gameData)

			self.game.level = game.level
			self.game.taps = game.taps
			self.game.levels = game.levels
		} catch {
		}
	}
}
