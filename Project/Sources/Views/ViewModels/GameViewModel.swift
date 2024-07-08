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

final class GameViewModel: ObservableObject {
	@Published var isTutorialLevel: Bool
	@Published var levelId: Int
	@Published var cells: [[CellState]]
	@Published var taps: Int
	@Published var isLevelCompleted: Bool

	var numberOfLevels: Int {
		gameManager.numberOfLevels
	}

	var levelSize: Int {
		cells.count
	}

	private let gameManager: IGameManager

	init(gameManager: IGameManager) {
		self.gameManager = gameManager

		isTutorialLevel = gameManager.currentLevelId == 0
		levelId = gameManager.currentLevelId
		cells = GameViewModel.mapCells(gameManager.currentLevelCells)
		taps = gameManager.tapsCount
		isLevelCompleted = false
	}

	func cellTapped(atX x: Int, atY y: Int) {
		guard x >= 0 && x < gameManager.currentLevelSize && y >= 0 && y < gameManager.currentLevelSize else {
			return
		}

		gameManager.toggleColors(atX: x, atY: y)
		updateLevel()

		switch gameManager.currentlevelStatus {
		case .completed:
			isLevelCompleted = true
		case .incompleted:
			isLevelCompleted = false
		}
	}

	func nextLevel() {
		gameManager.nextLevel()
		updateLevel()
		isTutorialLevel = gameManager.currentLevelId == 0
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

	func undoButtonTapped() {
		gameManager.undoLastTap()
		updateLevel()
	}

	func eraserButtonTapped() {
		gameManager.resetProgress()

		isTutorialLevel = true
		levelId = gameManager.currentLevelId
		cells = GameViewModel.mapCells(gameManager.currentLevelCells)
		taps = gameManager.tapsCount
		isLevelCompleted = false
	}

	private static func mapCells(_ cells: [[Int]]) -> [[CellState]] {
		cells.map { row in
			row.map { value in
				CellState(rawValue: value) ?? .empty
			}
		}
	}

	private func updateLevel() {
		levelId = gameManager.currentLevelId
		cells = GameViewModel.mapCells(gameManager.currentLevelCells)
		taps = gameManager.tapsCount
	}
}
