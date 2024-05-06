//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

struct Cell {
	var value: Int

	var isFlipped: Bool {
		value == 0 ? false : true
	}
}

protocol IGame {
	var field: [[Cell]] { get set }
}

struct Game: IGame {
	var field: [[Cell]]
}
