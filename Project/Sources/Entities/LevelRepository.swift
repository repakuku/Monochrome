//
//  LevelRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class LevelRepository {

	typealias LevelMatrix = [[Int]]

	var count: Int {
		matrices.count
	}

	private var matrices: [LevelMatrix] = [
		[
			[0]
		],
		[
			[0, 0],
			[1, 0]
		],
		[
			[0, 0],
			[1, 1]
		],
		[
			[1, 0],
			[1, 1]
		],
		[
			[1, 0, 0, 0],
			[0, 1, 1, 0],
			[0, 1, 1, 0],
			[0, 0, 0, 1]
		],
		[
			[1, 1, 1, 1],
			[1, 0, 0, 1],
			[1, 0, 0, 1],
			[1, 1, 1, 1]
		]
	]

	func getLevels() -> [Level] {
		var levels = [Level]()

		for index in 0..<count {
			let level = Level(
				id: index,
				cellsMatrix: matrices[index]
			)
			levels.append(level)
		}

		return levels
	}
}
