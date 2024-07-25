//
//  GameManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameManager {

	var game: Game { get }

	func fetchGame() async

	func toggleColors(atX x: Int, atY y: Int)
	func nextLevel()
	func restartLevel()
	func selectLevel(id: Int)
	func getHint()
	func getTapsForLevel(id: Int) -> Int
	func getStatusForLevel(id: Int) -> Bool
	func getStarsForLevel(id: Int, forCurrentGame: Bool) -> Int
	func undoLastTap()
	func resetProgress() async
}

final class GameManager: IGameManager {

	private let gameRepository: IGameRepository
	private let levelService: ILevelService

	private(set) var game: Game

	init(
		gameRepository: IGameRepository,
		levelService: ILevelService
	) {
		self.gameRepository = gameRepository
		self.levelService = levelService

		let startedlevel = Level(id: 0, cellsMatrix: [[0]])
		self.game = Game(
			level: startedlevel,
			taps: [],
			levels: [startedlevel],
			originLevels: [startedlevel],
			levelsHash: "hash"
		)
	}

	func fetchGame() async {
		self.game = await gameRepository.getGame()
	}

	func toggleColors(atX x: Int, atY y: Int) {
		guard x >= 0 && x < game.level.levelSize && y >= 0 && y < game.level.levelSize else {
			return
		}

		levelService.toggleColors(level: &game.level, atX: x, atY: y)

		game.taps.append(Tap(row: x, col: y))

		if levelService.checkMatrix(level: game.level) {
			completeLevel()
		}

		gameRepository.saveGame(game)
	}

	func nextLevel() {
		let nextLevelId = min(game.levels.count - 1, game.level.id + 1)
		game.level = game.originLevels[nextLevelId]
		game.taps = []

		gameRepository.saveGame(game)
	}

	func restartLevel() {
		game.taps = []
		game.level = game.originLevels[game.level.id]

		gameRepository.saveGame(game)
	}

	func selectLevel(id: Int) {
		guard id >= 0 && id < game.levels.count else {
			return
		}

		game.level = game.levels[id]
		game.level.status = .incompleted
		game.taps = []

		gameRepository.saveGame(game)
	}

	func getHint() {
		levelService.getHint(level: &game.level)
	}

	func getTapsForLevel(id: Int) -> Int {
		guard id >= 0 && id < game.levels.count else {
			return .zero
		}

		if case let .completed(taps) = game.levels[id].status {
			return taps
		}

		return .zero
	}

	func getStatusForLevel(id: Int) -> Bool {
		guard id >= 0 && id < game.levels.count else {
			return false
		}

		if case .completed = game.levels[id].status {
			return true
		}

		return false
	}

	func getStarsForLevel(id: Int, forCurrentGame: Bool = false) -> Int {
		guard id >= 0 && id < game.levels.count else {
			return .zero
		}

		let perfectScoreStars = 3
		let goodScoreStars = 2
		let basicScoreStars = 1
		let zeroScoreStars = 0

		let targetTaps = levelService.countTargetTaps(for: game.levels[id])
		let actualTaps: Int

		if forCurrentGame {
			actualTaps = game.taps.count
		} else if case let .completed(levelTaps) = game.levels[id].status {
			actualTaps = levelTaps
		} else {
			return zeroScoreStars
		}

		if actualTaps == targetTaps {
			return perfectScoreStars
		} else if actualTaps <= targetTaps * 2 {
			return goodScoreStars
		} else {
			return basicScoreStars
		}
	}

	func undoLastTap() {
		guard !game.taps.isEmpty else {
			return
		}

		let removedTap = game.taps.removeLast()
		levelService.toggleColors(level: &game.level, atX: removedTap.row, atY: removedTap.col)
	}

	func resetProgress() async {
		gameRepository.deleteSavedGame()
		self.game = await gameRepository.getGame()
	}

	private func completeLevel() {
		game.level.status = .completed(game.taps.count)

		if case let .completed(prevTaps) = game.levels[game.level.id].status {
			game.levels[game.level.id].status = .completed(min(game.taps.count, prevTaps))
		} else {
			game.levels[game.level.id].status = .completed(game.taps.count)
		}
	}
}

final class MockGameManager: IGameManager {

	var game = Game(
		level: Level(id: 0, cellsMatrix: [[0]]),
		taps: [],
		levels: [Level(id: 0, cellsMatrix: [[0]])],
		originLevels: [Level(id: 0, cellsMatrix: [[0]])],
		levelsHash: "hash"
	)

	var toggleColorsCalled = false
	var nextLevelCalled = false
	var restartLevelCalled = false
	var selectLevelCalled = false
	var getHintCalled = false

	var getTapsForLevelResult = 0
	var getStatusForLevelResult = false
	var getStarsForLevelResult = 0

	var undoLastTapCalled = false
	var resetProgressCalled = false

	func fetchGame() async {
		// TODO: complete
	}

	func toggleColors(atX x: Int, atY y: Int) {
		toggleColorsCalled = true
	}

	func nextLevel() {
		nextLevelCalled = true
	}

	func restartLevel() {
		restartLevelCalled = true
	}

	func selectLevel(id: Int) {
		selectLevelCalled = true
	}

	func getHint() {
		getHintCalled = true
	}

	func getTapsForLevel(id: Int) -> Int {
		getTapsForLevelResult
	}

	func getStatusForLevel(id: Int) -> Bool {
		getStatusForLevelResult
	}

	func getStarsForLevel(id: Int, forCurrentGame: Bool) -> Int {
		getStarsForLevelResult
	}

	func undoLastTap() {
		undoLastTapCalled = true
	}

	func resetProgress() async {
		resetProgressCalled = true
	}
}
