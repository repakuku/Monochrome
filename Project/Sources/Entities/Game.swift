//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Game {
	var field = [
		[0, 1],
		[1, 0]
	]

	var score = 0
	var level = 1

	var fieldSize: Int {
		field.count
	}

	mutating func toggleColors(atX x: Int, atY y: Int) {
		guard x < fieldSize && y < fieldSize else {
			return
		}

		for index in 0..<fieldSize {
			field[x][index] = 1 - field[x][index]
			if index != x {
				field[index][y] = 1 - field[index][y]
			}
		}
	}
}

// x = 1
// y = 2

// 0 1 0 1
// 1 0 1 0
// 0 0 1 1
// 1 1 1 1
