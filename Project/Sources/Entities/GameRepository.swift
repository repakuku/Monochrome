//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameRepository {
	func getNewGame(with levels: [Level]) -> Game
	func getSavedGame(from: URL?) -> Game?
	func saveGame(_: Game, toUrl: URL?)
	func deleteGame(from: URL?)
}

final class GameRepository: IGameRepository {

	func getNewGame(with levels: [Level]) -> Game {

		let levelsHash = HashService.calculateHash(of: levels)

		return Game(
			level: levels[0],
			taps: [],
			levels: levels,
			originLevels: levels,
			levelsHash: levelsHash
		)
	}

	func getSavedGame(from url: URL?) -> Game? {
		guard let savedGameUrl = url else {
			return nil
		}

		do {
			let savedGameData = try Data(contentsOf: savedGameUrl)
			let savedGame = try JSONDecoder().decode(Game.self, from: savedGameData)

			return Game(
				level: savedGame.level,
				taps: savedGame.taps,
				levels: savedGame.levels,
				originLevels: savedGame.originLevels,
				levelsHash: savedGame.levelsHash
			)
		} catch {
			return nil
		}
	}

	func saveGame(_ game: Game, toUrl url: URL?) {
		guard let gameUrl = url else {
			return
		}

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		if let gameData = try? encoder.encode(game) {
			try? gameData.write(to: gameUrl, options: .atomic)
		}
	}

	func deleteGame(from url: URL?) {
		guard let savedGameUrl = url else {
			return
		}

		try? FileManager.default.removeItem(at: savedGameUrl)
	}
}

final class StubGameRepository: IGameRepository {

	var saveGameCalled = false
	var deleteSavedGameCalled = false

	var game = Game(
		level: levels[0],
		taps: [],
		levels: levels,
		originLevels: levels,
		levelsHash: "hash"
	)

	private static let levels = [
		Level(id: 0, cellsMatrix: [[0]]),
		Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
		Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
		Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
		Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
		Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
	]

	func getNewGame(with levels: [Level]) -> Game {
		game
	}

	func getSavedGame(from: URL?) -> Game? {
		game
	}

	func saveGame(_: Game, toUrl: URL?) {
		saveGameCalled = true
	}

	func deleteGame(from: URL?) {
		deleteSavedGameCalled = true
	}
}
