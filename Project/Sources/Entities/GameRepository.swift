//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameRepository {
	func getGame(from: URL?) async -> Game
	func saveGame(_: Game, toUrl: URL?)
	func deleteSavedGame(from: URL?)
}

final class GameRepository: IGameRepository {

	private var levelRepository: ILevelRepository

	init(levelRepository: ILevelRepository) {
		self.levelRepository = levelRepository
	}

	func getGame(from url: URL?) async -> Game {
		guard let savedGameUrl = url else {
			return await getNewGame()
		}

		let decoder = JSONDecoder()

		if let savedGameData = try? Data(contentsOf: savedGameUrl),
		   let savedGame = try? decoder.decode(Game.self, from: savedGameData) {

			let newGame = await getNewGame()

			if newGame.levelsHash != savedGame.levelsHash {
				return newGame
			} else {
				return Game(
					level: savedGame.level,
					taps: savedGame.taps,
					levels: savedGame.levels,
					originLevels: savedGame.originLevels,
					levelsHash: savedGame.levelsHash
				)
			}
		} else {
			return await getNewGame()
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

	func deleteSavedGame(from url: URL?) {
		guard let savedGameUrl = url else {
			return
		}

		try? FileManager.default.removeItem(at: savedGameUrl)
	}

	private func getNewGame() async -> Game {

		var levels = levelRepository.getDefaultLevels(from: Endpoints.defaultLevelsUrl)

		if let newLevels = await levelRepository.fetchLevels(from: Endpoints.levelsUrl) {
			levels.append(contentsOf: newLevels)
		}

		let firstLevel = levels[0]
		let levelsHash = HashService.calculateHash(of: levels)

		return Game(
			level: firstLevel,
			taps: [],
			levels: levels,
			originLevels: levels,
			levelsHash: levelsHash
		)
	}
}

final class StubGameRepository: IGameRepository {

	var saveGameCalled = false
	var deleteSavedGameCalled = false

	var game = Game(
		level: Level(id: 0, cellsMatrix: [[0]]),
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

	func getGame(from: URL?) async -> Game {
		game
	}

	func saveGame(_: Game, toUrl: URL?) {
		saveGameCalled = true
	}

	func deleteSavedGame(from: URL?) {
		deleteSavedGameCalled = true
	}
}
