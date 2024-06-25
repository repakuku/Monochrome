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
		gameManager.levels.count
	}

	var levelSize: Int {
		cells.count
	}

	private let gameManager: IGameManager

	init(gameManager: IGameManager) {
		self.gameManager = gameManager

		isTutorialLevel = gameManager.level.id == 0
		levelId = gameManager.level.id
		cells = gameManager.level.cellsMatrix
		taps = gameManager.taps
		isLevelCompleted = false
	}

	func cellTapped(atX x: Int, atY y: Int) {
		gameManager.toggleColors(atX: x, atY: y)
		updateLevel()

		switch gameManager.level.status {
		case .completed:
			// TODO: tests
			isLevelCompleted = true
		case .incompleted:
			isLevelCompleted = false
		}
	}

	func nextLevel() {
		gameManager.nextLevel()
		updateLevel()
		isTutorialLevel = gameManager.level.id == 0
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
		gameManager.selectLevel(id: id)
		updateLevel()
	}

	func getTapsForLevel(id: Int) -> Int {
		gameManager.getTapsForLevel(id: id)
	}

	func getStatusForLevel(id: Int) -> Bool {
		gameManager.getStatusForLevel(id: id)
	}

	func getStarsForLevel(id: Int, forCurrentGame: Bool = false) -> Int {
		gameManager.getStarsForLevel(id: id, forCurrentGame: false)
	}

	private func updateLevel() {
		levelId = gameManager.level.id
		cells = gameManager.level.cellsMatrix
		taps = gameManager.taps
	}
}
