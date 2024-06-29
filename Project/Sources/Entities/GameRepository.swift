//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameRepository {
	func saveGame(_ game: Game, to gameUrl: URL?)
	func getGame(from savedGameUrl: URL?) -> Game
	func deleteSavedGame(from savedGameUrl: URL?)
}

final class GameRepository: IGameRepository {

	private var levelRepository: ILevelRepository

	init(levelRepository: ILevelRepository) {
		self.levelRepository = levelRepository
	}

	func saveGame(_ game: Game, to gameUrl: URL?) {
		guard let gameUrl = gameUrl else {
			return
		}

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		if let gameData = try? encoder.encode(game) {
			try? gameData.write(to: gameUrl, options: .atomic)
		}
	}

	func getGame(from savedGameUrl: URL?) -> Game {
		guard let savedGameUrl = savedGameUrl else {
			return getNewGame()
		}

		let decoder = JSONDecoder()

		if let savedGameData = try? Data(contentsOf: savedGameUrl),
		   let savedGame = try? decoder.decode(Game.self, from: savedGameData) {
			return Game(
				level: savedGame.level,
				taps: savedGame.taps,
				levels: savedGame.levels
			)
		} else {
			return getNewGame()
		}
	}

	func deleteSavedGame(from savedGameUrl: URL?) {
		guard let savedGameUrl = savedGameUrl else {
			return
		}

		try? FileManager.default.removeItem(at: savedGameUrl)
	}

	private func getNewGame() -> Game {
		let newLevels = levelRepository.getLevels()
		let firstLevel = newLevels[0]
		return Game(
			level: firstLevel,
			taps: [],
			levels: newLevels
		)
	}
}

final class StubGameRepository: IGameRepository {

	var saveGameCalled = false
	var deleteSavedGameCalled = false

	var game = Game(
		level: Level(id: 0, cellsMatrix: [[0]]),
		taps: [],
		levels: [
			Level(id: 0, cellsMatrix: [[0]]),
			Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
			Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
			Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
			Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
			Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
		]
	)

	func saveGame(_ game: Game, to gameUrl: URL?) {
		saveGameCalled = true
	}

	func getGame(from savedGameUrl: URL?) -> Game {
		game
	}

	func deleteSavedGame(from savedGameUrl: URL?) {
		deleteSavedGameCalled = true
	}
}
