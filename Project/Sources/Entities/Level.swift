//
//  Level.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/15/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Level {
	let id: Int
	var cellsMatrix: [[Int]]
	var isCompleted = false
	var taps: Int = 0

	var levelSize: Int {
		cellsMatrix.count
	}

	var answerMatrix: [[Int]] {
		getAnswerMatrix()
	}

	var targetTaps: Int {
		countTargetTaps()
	}

	init(id: Int, cellsMatrix: [[Int]]) {

		let isIncorrectMatrix = cellsMatrix.isEmpty || cellsMatrix.contains { $0.count != cellsMatrix.count }

		if id < 0 || isIncorrectMatrix {
			self.id = 0
			self.cellsMatrix = [[0]]
		} else {
			self.id = id
			self.cellsMatrix = cellsMatrix
		}
	}

	private func getAnswerMatrix() -> [[Int]] {
		let row = Array(repeating: 0, count: levelSize)
		var answerMatrix = Array(repeating: row, count: levelSize)

		for row in 0..<levelSize {
			for col in 0..<levelSize {
				if cellsMatrix[row][col] == 0 {
					for index in 0..<levelSize {
						answerMatrix[row][index] = 1 - answerMatrix[row][index]
						if index != row {
							answerMatrix[index][col] = 1 - answerMatrix[index][col]
						}
					}
				}
			}
		}

		return answerMatrix
	}

	private func countTargetTaps() -> Int {
		var steps = 0

		for row in 0..<levelSize {
			for col in 0..<levelSize {
				if answerMatrix[row][col] == 1 {
					steps += 1
				}
			}
		}

		return steps
	}
}
