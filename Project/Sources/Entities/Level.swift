//
//  Level.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/15/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum LevelStatus: Equatable, Codable {
	case completed(Int)
	case incompleted

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		if let taps = try? container.decode(Int.self, forKey: .completed) {
			self = .completed(taps)
		} else {
			self = .incompleted
		}
	}

	private enum CodingKeys: String, CodingKey {
		case completed
		case incompleted
	}

	static func == (lhs: LevelStatus, rhs: LevelStatus) -> Bool {
		switch (lhs, rhs) {
		case (.completed(let lhsTaps), .completed(let rhsTaps)):
			return lhsTaps == rhsTaps
		case (.incompleted, .incompleted):
			return true
		default:
			return false
		}
	}
}

struct Level: Codable {
	let id: Int
	var cellsMatrix: [[Int]]
	var status: LevelStatus

	var levelSize: Int {
		cellsMatrix.count
	}

	init(id: Int, cellsMatrix: [[Int]]) {

		let isIncorrectMatrix = cellsMatrix.isEmpty || cellsMatrix.contains { $0.count != cellsMatrix.count }

		if id < 0 || isIncorrectMatrix {
			self.id = 0
			self.cellsMatrix = [[0]]
		} else {
			self.id = id
			self.cellsMatrix = cellsMatrix
		}

		self.status = .incompleted
	}
}
