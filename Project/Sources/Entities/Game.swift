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

	init() {
		level = 0
		steps = 0
		field = Field(cells: [[0]])
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
	}

	mutating func restart() {
		steps = 0
		showInstructions = true
		field = repository.getField(forLevel: level)
	}

	mutating func nextGame() {
		level += 1

		if level > maxLevel {
			level = maxLevel
		}

		steps = 0
		field = repository.getField(forLevel: level)
	}

	private func checkField() -> Bool {
		for row in field.cells {
			for cell in row where cell == 0 {
				return false
			}
		}

		return true
	}
}
