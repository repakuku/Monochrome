//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/24/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Tap: Codable, Equatable {
	let row: Int
	let col: Int

	static func == (lhs: Tap, rhs: Tap) -> Bool {
		if lhs.col == rhs.col && lhs.row == rhs.row {
			return true
		} else {
			return false
		}
	}
}

struct Game: Codable, Equatable {
	var level: Level
	var taps: [Tap]
	var levels: [Level]

	static func == (lhs: Game, rhs: Game) -> Bool {
		if lhs.level == rhs.level
			&& lhs.taps == rhs.taps
			&& lhs.levels == rhs.levels {
			return true
		} else {
			return false
		}
	}
}
