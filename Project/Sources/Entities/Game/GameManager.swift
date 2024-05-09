//
//  GameManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/9/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class GameManager: ObservableObject {
	@Published private(set) var game: Game

	private let gameRepository: IGameRepository

	init() {
		self.gameRepository = MockGameRepository()
		self.game = gameRepository.getGame()
	}
}
