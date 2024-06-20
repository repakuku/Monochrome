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
	@Published var taps: Int
	@Published var levels: [Level]

	var isLevelCompleted: Bool {
		switch level.status {
		case .completed:
			true
		case .incompleted:
			false
		}
	}

	private let levelRepository: ILevelRepository
	private let levelService: ILevelService

	private let originLevels: [Level]

	init(levelRepository: ILevelRepository, levelService: ILevelService) {
		self.levelRepository = levelRepository
		self.levelService = levelService

		originLevels = levelRepository.getLevels()
		levels = originLevels
		level = originLevels[0]
		taps = 0
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

	private func completeLevel() {
		level.status = .completed(taps)

		if case let .completed(prevTaps) = levels[level.id].status {
			levels[level.id].status = .completed(min(taps, prevTaps))
		} else {
			levels[level.id].status = .completed(taps)
		}
	}

	func restartLevel() {
		taps = 0
		level = originLevels[level.id]
	}

	func nextLevel() {
		var nextLevelId = level.id + 1

		if nextLevelId > levels.count - 1 {
			nextLevelId = levels.count - 1
		}

		level = originLevels[nextLevelId]
		taps = 0
	}

	func getHint() {
		levelService.getHint(level: &level)
	}

	func getTapsForLevel(id: Int) -> Int {
		guard id >= 0 else {
			return .zero
		}

		let level = levels[id]
		let status = level.status
		var levelTaps = 0

		if case let .completed(taps) = status {
			levelTaps = taps
		}

		return levelTaps
	}

	func getStatusForLevel(id: Int) -> Bool {
		guard id >= 0 else {
			return false
		}

		let level = levels[id]
		var status = false

		switch level.status {
		case .completed:
			status = true
		case .incompleted:
			status = false
		}

		return status
	}
}
