//
//  GameManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class GameManager: ObservableObject {

	@Published var level: Level
	@Published var isLevelComplited: Bool
	@Published var taps: Int

	private let repository: LevelRepository
	private let levels: [Level]

	init() {
		repository = LevelRepository()
		levels = repository.getLevels()
		level = levels[0]
		isLevelComplited = false
		taps = 0
	}

	func toggleColors(atX x: Int, atY y: Int) {
		guard x >= 0 && x < level.levelSize && y >= 0 && y < level.levelSize else {
			return
		}

		clearHint()

		for index in 0..<level.levelSize {
			level.cellsMatrix[x][index] = 1 - level.cellsMatrix[x][index]
			if index != x {
				level.cellsMatrix[index][y] = 1 - level.cellsMatrix[index][y]
			}
		}

		taps += 1

		if checkMatrix() {
			level.isCompleted = true
			isLevelComplited = true
		}
	}

	func restartLevel() {
		taps = 0
		level = levels[level.id]
		isLevelComplited = false
	}

	func nextLevel() {
		var nextLevelId = level.id + 1

		if nextLevelId > levels.count - 1 {
			nextLevelId = levels.count - 1
		}

		level = levels[nextLevelId]
		taps = 0
		isLevelComplited = false
	}

	func getHint() {
		let answerMatrix = level.answerMatrix

		for row in 0..<level.levelSize {
			for col in 0..<level.levelSize {
				if answerMatrix[row][col] == 1 {
					if level.cellsMatrix[row][col] == 0 {
						level.cellsMatrix[row][col] = 2
					} else {
						level.cellsMatrix[row][col] = 3
					}
					return
				}
			}
		}
	}

	private func checkMatrix() -> Bool {
		for row in level.cellsMatrix {
			for cell in row where cell == 0 {
				return false
			}
		}

		return true
	}

	private func clearHint() {
		for row in 0..<level.levelSize {
			for con in 0..<level.levelSize {
				if level.cellsMatrix[row][con] == 2 {
					level.cellsMatrix[row][con] = 0
				} else if level.cellsMatrix[row][con] == 3 {
					level.cellsMatrix[row][con] = 1
				}
			}
		}
	}
}
