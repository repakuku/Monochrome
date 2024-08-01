//
//  LevelRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ILevelRepository {
	func getDefaultLevels(from: URL?) -> [Level]
	func fetchLevels(from: URL?) async -> [Level]?
}

final class LevelRepository: ILevelRepository {

	func fetchLevels(from url: URL?) async -> [Level]? {
		guard let url = url else {
			return nil
		}

		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			return try JSONDecoder().decode([Level].self, from: data)
		} catch {
			return nil
		}
	}

	func getDefaultLevels(from url: URL?) -> [Level] {
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
	var levels = [
		Level(id: 0, cellsMatrix: [[0]]),
		Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
		Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
		Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
		Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
		Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
	]

	var fetchedLevels: [Level]?

	func getDefaultLevels(from: URL?) -> [Level] {
		levels.sortedById()
	}

	func fetchLevels(from: URL?) async -> [Level]? {
		fetchedLevels
	}
}
