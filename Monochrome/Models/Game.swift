//
//  Game.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

protocol IGame {
	var field: [[Int]] { get set }
}

struct Game: IGame {
	var field: [[Int]]
}
