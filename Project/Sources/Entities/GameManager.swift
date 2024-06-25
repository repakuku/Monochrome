//
//  GameManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class GameManager {

	var level: Level
	var taps: Int
	var levels: [Level]

	private let levelRepository: ILevelRepository
	private let levelService: ILevelService
	private let originLevels: [Level]

	init(levelRepository: ILevelRepository, levelService: ILevelService) {
		self.levelRepository = levelRepository
		self.levelService = levelService

		originLevels = levelRepository.getLevels()
		level = originLevels[0]
		taps = 0
		levels = originLevels
	}

	func toggleColors(atX x: Int, atY y: Int) {
		guard x >= 0 && x < level.levelSize && y >= 0 && y < level.levelSize else {
			return
		}

		levelService.toggleColors(level: &level, atX: x, atY: y)

		taps += 1

		if levelService.checkMatrix(level: level) {
			completeLevel()
		}
	}

	func nextLevel() {
		let nextLevelId = min(levels.count - 1, level.id + 1)
		level = originLevels[nextLevelId]
		taps = 0
	}

	func restartLevel() {
		taps = 0
		level = originLevels[level.id]
	}

	func selectLevel(id: Int) {
		guard id >= 0 && id < levels.count else {
			return
		}

		level = levels[id]
		level.status = .incompleted
		taps = 0
	}

	func getHint() {
		levelService.getHint(level: &level)
	}

	func getTapsForLevel(id: Int) -> Int {
		guard id >= 0 && id < levels.count else {
			return .zero
		}

		if case let .completed(taps) = levels[id].status {
			return taps
		}

		return .zero
	}

	func getStatusForLevel(id: Int) -> Bool {
		guard id >= 0 && id < levels.count else {
			return false
		}

		if case .completed = levels[id].status {
			return true
		}

		return false
	}

	func getStarsForLevel(id: Int, forCurrentGame: Bool = false) -> Int {
		let perfectScoreStars = 3
		let goodScoreStars = 2
		let basicScoreStars = 1
		let zeroScoreStars = 0

		guard id >= 0 && id < levels.count else {
			return zeroScoreStars
		}

		let targetTaps = levelService.countTargetTaps(for: levels[id])
		let actualTaps: Int

		if forCurrentGame {
			actualTaps = taps
		} else if case let .completed(levelTaps) = levels[id].status {
			actualTaps = levelTaps
		} else {
			return zeroScoreStars
		}

		if actualTaps == targetTaps {
			return perfectScoreStars
		} else if actualTaps <= targetTaps * 2 {
			return goodScoreStars
		} else {
			return basicScoreStars
		}
	}

	private func completeLevel() {
		level.status = .completed(taps)

		if case let .completed(prevTaps) = levels[level.id].status {
			levels[level.id].status = .completed(min(taps, prevTaps))
		} else {
			levels[level.id].status = .completed(taps)
		}
	}
}

//	private func saveGame() {
//		let game = Game(
//			level: level,
//			taps: taps,
//			levels: levels
//		)
//
//		let encoder = JSONEncoder()
//		encoder.outputFormatting = .prettyPrinted
//
//		do {
//			let gameData = try encoder.encode(game)
//			try gameData.write(to: Endpoints.gameUrl, options: .atomic)
//		} catch {
//			// TODO: log error
//		}
//	}
//
//	private func loadGame() {
//		do {
//			let gameData = try Data(contentsOf: Endpoints.gameUrl)
//			let game = try JSONDecoder().decode(Game.self, from: gameData)
//
//			self.level = game.level
//			self.taps = game.taps
//			self.levels = game.levels
//		} catch {
//			// TODO: log error
//		}
//	}
