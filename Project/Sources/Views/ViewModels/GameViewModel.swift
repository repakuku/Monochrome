//
//  GameViewModel.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/24/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum CellState: Int {
	case empty = 0
	case filled
	case hintEmpty
	case hintFilled
}

@MainActor
final class GameViewModel: ObservableObject {
	@Published var levelId: Int
	@Published var cells: [[CellState]]
	@Published var taps: Int
	@Published var isLevelCompleted: Bool
	@Published var isTutorialLevel: Bool

	var numberOfLevels: Int {
		gameManager.game.levels.count
	}

	var levelSize: Int {
		cells.count
	}

	private let gameManager: IGameManager

	private var game: Game {
		gameManager.game
	}

	init(gameManager: IGameManager) {
		self.gameManager = gameManager

		self.levelId = gameManager.game.level.id
		self.cells = GameViewModel.mapCells(gameManager.game.level.cellsMatrix)
		self.taps = gameManager.game.taps.count
		self.isLevelCompleted = false
		self.isTutorialLevel = gameManager.game.level.id == 0

		Task {
			await gameManager.updateGame()
			updateViewModel()
		}
	}

	func cellTapped(atX x: Int, atY y: Int) {
		guard x >= 0 && x < game.level.levelSize && y >= 0 && y < game.level.levelSize else {
			return
		}

		gameManager.toggleColors(atX: x, atY: y)
		updateViewModel()

		switch game.level.status {
		case .completed:
			isLevelCompleted = true
		case .incompleted:
			isLevelCompleted = false
		}
	}

	func nextLevel() {
		gameManager.nextLevel()
		updateViewModel()
		isTutorialLevel = game.level.id == 0
		isLevelCompleted = false
	}

	func restartLevel() {
		gameManager.restartLevel()
		updateViewModel()
		isLevelCompleted = false
	}

	func getHint() {
		gameManager.getHint()
		updateViewModel()
	}

	func selectLevel(id: Int) {
		guard id >= 0 && id < numberOfLevels else {
			return
		}

		gameManager.selectLevel(id: id)
		updateViewModel()
	}

	func getTapsForLevel(id: Int) -> Int {
		guard id >= 0 && id < numberOfLevels else {
			return .zero
		}

		return gameManager.getTapsForLevel(id: id)
	}

	func getStatusForLevel(id: Int) -> Bool {
		guard id >= 0 && id < numberOfLevels else {
			return false
		}

		return gameManager.getStatusForLevel(id: id)
	}

	func getStarsForLevel(id: Int, forCurrentGame: Bool = false) -> Int {
		guard id >= 0 && id < numberOfLevels else {
			return .zero
		}

		return gameManager.getStarsForLevel(id: id, forCurrentGame: false)
	}

	func undoButtonTapped() {
		gameManager.undoLastTap()
		updateViewModel()
	}

	func eraserButtonTapped() {
		Task {
			gameManager.resetProgress()
			await gameManager.updateGame()
			updateViewModel()
		}
	}

	private static func mapCells(_ cells: [[Int]]) -> [[CellState]] {
		cells.map { row in
			row.map { value in
				CellState(rawValue: value) ?? .empty
			}
		}
	}

	private func updateViewModel() {
		self.levelId = game.level.id
		self.cells = GameViewModel.mapCells(game.level.cellsMatrix)
		self.taps = game.taps.count
		self.isLevelCompleted = false
		self.isTutorialLevel = gameManager.game.level.id == 0
	}
}
