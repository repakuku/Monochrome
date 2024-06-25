//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/24/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Game: Codable {
	var level: Level
	var taps: Int
	var levels: [Level]
}
