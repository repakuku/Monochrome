//
//  GameViewModel.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/24/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class GameViewModel: ObservableObject {
	@Published var isTutorialLevel: Bool
	@Published var levelId: Int
	@Published var cells: [[Int]]
	@Published var taps: Int
	@Published var isLevelCompleted: Bool

	var numberOfLevels: Int {
		gameManager.game.levels.count
	}

	var levelSize: Int {
		cells.count
	}

	private let gameManager: IGameManager

	init(gameManager: IGameManager) {
		self.gameManager = gameManager

		isTutorialLevel = gameManager.game.level.id == 0
		levelId = gameManager.game.level.id
		cells = gameManager.game.level.cellsMatrix
		taps = gameManager.game.taps
		isLevelCompleted = false
	}

	func cellTapped(atX x: Int, atY y: Int) {
		guard x >= 0 && x < gameManager.game.level.levelSize && y >= 0 && y < gameManager.game.level.levelSize else {
			return
		}

		gameManager.toggleColors(atX: x, atY: y)
		updateLevel()

		switch gameManager.game.level.status {
		case .completed:
			isLevelCompleted = true
		case .incompleted:
			isLevelCompleted = false
		}
	}

	func nextLevel() {
		gameManager.nextLevel()
		updateLevel()
		isTutorialLevel = gameManager.game.level.id == 0
		isLevelCompleted = false
	}

	func restartLevel() {
		gameManager.restartLevel()
		updateLevel()
		isLevelCompleted = false
	}

	func getHint() {
		gameManager.getHint()
		updateLevel()
	}

	func selectLevel(id: Int) {
		guard id >= 0 && id < numberOfLevels else {
			return
		}

		gameManager.selectLevel(id: id)
		updateLevel()
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

	private func updateLevel() {
		levelId = gameManager.game.level.id
		cells = gameManager.game.level.cellsMatrix
		taps = gameManager.game.taps
	}
}
