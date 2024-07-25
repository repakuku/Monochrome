//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameRepository {
	func saveGame(_ game: Game)
	func getGame() async -> Game
	func deleteSavedGame()
}

final class GameRepository: IGameRepository {

	private var levelRepository: ILevelRepository
	private var levels: [Level] = []

	init(levelRepository: ILevelRepository) {
		self.levelRepository = levelRepository
	}

	func saveGame(_ game: Game) {
		let gameUrl = Endpoints.gameUrl

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		if let gameData = try? encoder.encode(game) {
			try? gameData.write(to: gameUrl, options: .atomic)
		}
	}

	func getGame() async -> Game {
		let savedGameUrl = Endpoints.gameUrl

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

	func deleteSavedGame() {
		let savedGameUrl = Endpoints.gameUrl

		try? FileManager.default.removeItem(at: savedGameUrl)
	}

	private func getNewGame() async -> Game {

		levels = levelRepository.getDefaultLevels(from: Endpoints.defaultLevelsUrl)

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

	func saveGame(_ game: Game) {
		saveGameCalled = true
	}

	func getGame() async -> Game {
		game
	}

	func deleteSavedGame() {
		deleteSavedGameCalled = true
	}
}
