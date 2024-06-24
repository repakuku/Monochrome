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

	init() {
		self.levels = loadJsonLevels()
	}

	func getLevels() -> [Level] {
		levels
	}

	private func loadJsonLevels() -> [Level] {
		guard let levelsJsonUrl = Bundle.main.url(forResource: "Levels", withExtension: "json") else {
			return [Level(id: 0, cellsMatrix: [[0]])]
		}

		do {
			let jsonLevelsData = try Data(contentsOf: levelsJsonUrl)
			return try JSONDecoder().decode([Level].self, from: jsonLevelsData)
		} catch {
			// TODO: log error
			return [Level(id: 0, cellsMatrix: [[0]])]
		}
	}
}
