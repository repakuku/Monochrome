//
//  LevelService.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/20/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ILevelService {
	func toggleColors(level: inout Level, atX: Int, atY: Int)
	func checkMatrix(level: Level) -> Bool
	func getHint(level: inout Level)
}

final class LevelService: ILevelService {
	func toggleColors(level: inout Level, atX x: Int, atY y: Int) {
		guard x >= 0 && x < level.levelSize && y >= 0 && y < level.levelSize else {
			return
		}

		clearHint(level: &level)

		for index in 0..<level.levelSize {
			level.cellsMatrix[x][index] = 1 - level.cellsMatrix[x][index]
			if index != x {
				level.cellsMatrix[index][y] = 1 - level.cellsMatrix[index][y]
			}
		}

		level.taps += 1
	}

	func checkMatrix(level: Level) -> Bool {
		for row in level.cellsMatrix {
			for cell in row where cell == 0 {
				return false
			}
		}

		return true
	}

	func getHint(level: inout Level) {
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

	private func clearHint(level: inout Level) {
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
