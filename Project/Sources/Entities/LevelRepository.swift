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

	func getLevels() -> [Level] {
		levels = loadJsonLevels()
		return levels
	}

	private func loadJsonLevels() -> [Level] {
		guard let levelsJsonUrl = Bundle.main.url(forResource: "Levels", withExtension: "json") else {
			return []
		}

		var levels = [Level]()

		do {
			let levelsData = try Data(contentsOf: levelsJsonUrl)
			levels = try JSONDecoder().decode([Level].self, from: levelsData)
		} catch {
			// TODO: log error
			print(error)
		}

		return levels
	}
}
