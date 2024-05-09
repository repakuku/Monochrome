//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

struct Cell: Codable {
	var value: Int

	var isFlipped: Bool {
		value == 0 ? false : true
	}
}

struct Game: Codable {
	var field: [[Cell]]
}
