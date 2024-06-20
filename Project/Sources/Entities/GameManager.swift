//
//  GameManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class GameManager: ObservableObject {

	@Published var level: Level
	@Published var isLevelCompleted: Bool
	@Published var targetTaps: Int
	@Published var levels: [Level]

	private let levelRepository: ILevelRepository
	private let levelService: ILevelService

	private let originLevels: [Level]

	init(levelRepository: ILevelRepository, levelService: ILevelService) {
		self.levelRepository = levelRepository
		self.levelService = levelService

		originLevels = levelRepository.getLevels()
		levels = originLevels
		level = originLevels[0]
		isLevelCompleted = false
		targetTaps = originLevels[0].targetTaps
	}

	func toggleColors(atX x: Int, atY y: Int) {
		levelService.toggleColors(level: &level, atX: x, atY: y)

		if levelService.checkMatrix(level: level) {
			level.isCompleted = true
			isLevelCompleted = true
			levels[level.id].isCompleted = true
			levels[level.id].taps = level.taps
		}
	}

	func restartLevel() {
		level.taps = 0
		level = originLevels[level.id]
		isLevelCompleted = false
	}

	func nextLevel() {
		var nextLevelId = level.id + 1

		if nextLevelId > levels.count - 1 {
			nextLevelId = levels.count - 1
		}

		level = originLevels[nextLevelId]
		level.taps = 0
		isLevelCompleted = false
		targetTaps = level.targetTaps
	}

	func getHint() {
		levelService.getHint(level: &level)
	}
}
