//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Field {
	var cells: [[Int]]
	var isSolved = false
}

struct Game {
	var level: Int
	var field: Field
	var targetSteps: Int
	var steps: Int
	var showInstructions: Bool
	var fieldSize: Int {
		field.cells.count
	}

	var gameCompleted: Bool {
		field.isSolved
	}

	var maxLevel: Int {
		repository.count - 1
	}

	private let repository = FieldRepository()

	private var answerMatrix = [[0]]

	init() {
		level = 0
		targetSteps = 1
		steps = 0
		field = Field(cells: [[0]])
		answerMatrix = [[1]]
		showInstructions = true
	}

	mutating func toggleColors(atX x: Int, atY y: Int) {
		guard x >= 0 && x < fieldSize && y >= 0 && y < fieldSize else {
			return
		}

		for index in 0..<fieldSize {
			field.cells[x][index] = 1 - field.cells[x][index]
			if index != x {
				field.cells[index][y] = 1 - field.cells[index][y]
			}
		}

		steps += 1

		if checkField() {
			field.isSolved = true
		}

		if showInstructions {
			showInstructions = false
		}
	}

	mutating func restart() {
		steps = 0
		field = repository.getField(forLevel: level)
		answerMatrix = findAnswerMatrix(forField: field)
	}

	mutating func nextGame() {
		level += 1

		if level > maxLevel {
			level = maxLevel
		}

		steps = 0
		field = repository.getField(forLevel: level)

		answerMatrix = findAnswerMatrix(forField: field)
		targetSteps = countSteps(forAnswerMatrix: answerMatrix)
	}

	mutating func getHint() -> (Int, Int) {
		var hint = (0, 0)

		for row in 0..<fieldSize {
			for col in 0..<fieldSize {
				if answerMatrix[row][col] == 1 {
					hint = (row, col)
					answerMatrix[row][col] = 0
					return hint
				}
			}
		}

		return hint
	}

	private func checkField() -> Bool {
		for row in field.cells {
			for cell in row where cell == 0 {
				return false
			}
		}

		return true
	}

	private func findAnswerMatrix(forField field: Field) -> [[Int]] {
		let row = Array(repeating: 0, count: fieldSize)
		var answerMatrix = Array(repeating: row, count: fieldSize)

		for row in 0..<fieldSize {
			for col in 0..<fieldSize {
				if field.cells[row][col] == 0 {
					for index in 0..<fieldSize {
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

	private func countSteps(forAnswerMatrix answerMatrix: [[Int]]) -> Int {
		var steps = 0

		for row in 0..<fieldSize {
			for col in 0..<fieldSize {
				if answerMatrix[row][col] == 1 {
					steps += 1
				}
			}
		}

		return steps
	}
}
