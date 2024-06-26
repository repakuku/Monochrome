//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/24/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Game: Codable, Equatable {
	var level: Level
	var taps: Int
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
