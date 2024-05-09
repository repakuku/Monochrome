//
//  GameRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/9/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IGameRepository {
	func getGame() -> Game
	func save(game: Game) -> Bool
}

final class MockGameRepository: IGameRepository {
	func getGame() -> Game {
		Game(
			field: [
				[Cell(value: 0), Cell(value: 1)],
				[Cell(value: 1), Cell(value: 0)]
			]
		)
	}

	func save(game: Game) -> Bool {
		true
	}
}
