//
//  LevelRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ILevelRepository {
	func getLevels() -> [Level]
}

final class LevelRepository: ILevelRepository {

	private var levels: [Level] = []

	init(levelsJsonUrl: URL?) {
		self.levels = loadJsonLevels(from: levelsJsonUrl)
	}

	func getLevels() -> [Level] {
		levels
	}

	private func loadJsonLevels(from url: URL?) -> [Level] {
		guard let url = url else {
			return [Level(id: 0, cellsMatrix: [[0]])]
		}

		do {
			let jsonLevelsData = try Data(contentsOf: url)
			return try JSONDecoder().decode([Level].self, from: jsonLevelsData)
		} catch {
			return [Level(id: 0, cellsMatrix: [[0]])]
		}
	}
}

final class StubLevelRepository: ILevelRepository {
	var levels: [Level] = [
		Level(
			id: 0,
			cellsMatrix: [
				[0]
			]
		),
		Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		),
		Level(
			id: 2,
			cellsMatrix: [
				[0, 0],
				[1, 1]
			]
		),
		Level(
			id: 3,
			cellsMatrix: [
				[1, 0],
				[1, 1]
			]
		),
		Level(
			id: 4,
			cellsMatrix: [
				[1, 0, 0, 0],
				[0, 1, 1, 0],
				[0, 1, 1, 0],
				[0, 0, 0, 1]
			]
		),
		Level(
			id: 5,
			cellsMatrix: [
				[1, 1, 1, 1],
				[1, 0, 0, 1],
				[1, 0, 0, 1],
				[1, 1, 1, 1]
			]
		)
	]

	func getLevels() -> [Level] {
		levels
	}
}
