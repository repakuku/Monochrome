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
}

struct Game {
	var field = Field(
		cells: [
			[0, 0],
			[1, 0]
		]
	)

	var level = 1

	var fields: [Field]

	var showInstructions = true

	var fieldSize: Int {
		field.cells.count
	}

	init() {
		fields = [field]
	}

	mutating func toggleColors(atX x: Int, atY y: Int) {
		guard x < fieldSize && y < fieldSize else {
			return
		}

		for index in 0..<fieldSize {
			field.cells[x][index] = 1 - field.cells[x][index]
			if index != x {
				field.cells[index][y] = 1 - field.cells[index][y]
			}
		}
	}

	mutating func restart() {
		showInstructions = true
		field = fields[level - 1]
	}
}
