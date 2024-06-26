//
//  GameManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameManager {

	var numberOfLevels: Int { get }
	var currentLevelId: Int { get }
	var currentLevelCells: [[Int]] { get }
	var currentTaps: Int { get }
	var currentLevelSize: Int { get }
	var currentlevelStatus: LevelStatus { get }

	func toggleColors(atX x: Int, atY y: Int)
	func nextLevel()
	func restartLevel()
	func selectLevel(id: Int)
	func getHint()
	func getTapsForLevel(id: Int) -> Int
	func getStatusForLevel(id: Int) -> Bool
	func getStarsForLevel(id: Int, forCurrentGame: Bool) -> Int

	func resetProgress()
}

final class GameManager: IGameManager {

	var numberOfLevels: Int {
		game.levels.count
	}

	var currentLevelId: Int {
		game.level.id
	}

	var currentLevelCells: [[Int]] {
		game.level.cellsMatrix
	}

	var currentTaps: Int {
		game.taps
	}

	var currentLevelSize: Int {
		game.level.levelSize
	}

	var currentlevelStatus: LevelStatus {
		game.level.status
	}

	private let gameRepository: IGameRepository
	private let levelRepository: ILevelRepository
	private let levelService: ILevelService

	private let originLevels: [Level]
	private let gameUrl: URL?

	private var game: Game

	init(
		gameRepository: IGameRepository,
		levelRepository: ILevelRepository,
		levelService: ILevelService
	) {
		self.gameRepository = gameRepository
		self.levelRepository = levelRepository
		self.levelService = levelService

		originLevels = levelRepository.getLevels()
		game = gameRepository.getGame(from: Endpoints.gameUrl)
		gameUrl = Endpoints.gameUrl
	}

	func toggleColors(atX x: Int, atY y: Int) {
		guard x >= 0 && x < game.level.levelSize && y >= 0 && y < game.level.levelSize else {
			return
		}

		levelService.toggleColors(level: &game.level, atX: x, atY: y)

		game.taps += 1

		if levelService.checkMatrix(level: game.level) {
			completeLevel()
		}

		gameRepository.saveGame(game, to: gameUrl)
	}

	func nextLevel() {
		let nextLevelId = min(game.levels.count - 1, game.level.id + 1)
		game.level = originLevels[nextLevelId]
		game.taps = 0

		gameRepository.saveGame(game, to: gameUrl)
	}

	func restartLevel() {
		game.taps = 0
		game.level = originLevels[game.level.id]

		gameRepository.saveGame(game, to: gameUrl)
	}

	func selectLevel(id: Int) {
		guard id >= 0 && id < game.levels.count else {
			return
		}

		game.level = game.levels[id]
		game.level.status = .incompleted
		game.taps = 0

		gameRepository.saveGame(game, to: gameUrl)
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
			actualTaps = game.taps
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

	func resetProgress() {
		gameRepository.deleteSavedGame(from: gameUrl)
		game = gameRepository.getGame(from: gameUrl)
	}

	private func completeLevel() {
		game.level.status = .completed(game.taps)

		if case let .completed(prevTaps) = game.levels[game.level.id].status {
			game.levels[game.level.id].status = .completed(min(game.taps, prevTaps))
		} else {
			game.levels[game.level.id].status = .completed(game.taps)
		}
	}
}

final class MockGameManager: IGameManager {

	var numberOfLevels: Int {
		game.levels.count
	}

	var currentLevelId: Int {
		game.level.id
	}

	var currentLevelCells: [[Int]] {
		game.level.cellsMatrix
	}

	var currentTaps: Int {
		game.taps
	}

	var currentLevelSize: Int {
		game.level.levelSize
	}

	var currentlevelStatus: LevelStatus {
		game.level.status
	}

	var game = Game(
		level: Level(id: 0, cellsMatrix: [[0]]),
		taps: 0,
		levels: [Level(id: 0, cellsMatrix: [[0]])]
	)

	var toggleColorsCalled = false
	var nextLevelCalled = false
	var restartLevelCalled = false
	var selectLevelCalled = false
	var getHintCalled = false

	var getTapsForLevelResult = 0
	var getStatusForLevelResult = false
	var getStarsForLevelResult = 0

	var resetProgressCalled = false

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

	// TODO: Test
	func resetProgress() {
		resetProgressCalled = true
	}
}
