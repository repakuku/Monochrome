//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameRepository {
	func getNewGame() -> Game
	func getSavedGame(from: URL?) -> Game?
	func saveGame(_: Game, toUrl: URL?)
	func deleteGame(from: URL?)
}

final class GameRepository: IGameRepository {

	func getNewGame() -> Game {
        let tutorialLevel = Level(id: 0, cellsMatrix: [[0]])
		return Game(
            level: tutorialLevel,
            taps: [],
            levels: [tutorialLevel]
        )
	}

	func getSavedGame(from url: URL?) -> Game? {
		guard let savedGameUrl = url else {
			return nil
		}

		do {
			let savedGameData = try Data(contentsOf: savedGameUrl)
			let savedGame = try JSONDecoder().decode(Game.self, from: savedGameData)
			return savedGame
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

	var savedGame: Game?

	func getNewGame() -> Game {
		let tutorialLevel = Level(id: 0, cellsMatrix: [[0]])

        return Game(
            level: tutorialLevel,
            taps: [],
            levels: [tutorialLevel]
        )
	}

	func getSavedGame(from: URL?) -> Game? {
		savedGame
	}

	func saveGame(_: Game, toUrl: URL?) {
		saveGameCalled = true
	}

	func deleteGame(from: URL?) {
		deleteSavedGameCalled = true
	}
}
