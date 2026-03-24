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

	private enum CodingKeys: String, CodingKey {
		case type
		case taps
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)
		switch type {
		case "completed":
			let taps = try container.decode(Int.self, forKey: .taps)
			self = .completed(taps)
		case "incompleted":
			self = .incompleted
		default:
			throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid status type")
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .completed(let taps):
			try container.encode("completed", forKey: .type)
			try container.encode(taps, forKey: .taps)
		case .incompleted:
			try container.encode("incompleted", forKey: .type)
		}
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

struct Level: Codable, Equatable, Identifiable {
	let id: Int
	var cellsMatrix: [[Int]]
	var status: LevelStatus

	var levelSize: Int {
		cellsMatrix.count
	}

    var isTutorial: Bool {
        id == 0
    }

    var isCompleted: Bool {
        cellsMatrix.allSatisfy { row in row.allSatisfy { $0 == 1 } }
    }

	init(id: Int, cellsMatrix: [[Int]], status: LevelStatus = .incompleted) {

		let isIncorrectMatrix = cellsMatrix.isEmpty || cellsMatrix.contains { $0.count != cellsMatrix.count }

		if id < 0 || isIncorrectMatrix {
			self.id = 0
			self.cellsMatrix = [[0]]
		} else {
			self.id = id
			self.cellsMatrix = cellsMatrix
		}

		self.status = status
	}

    func isEquivalent(to other: Level) -> Bool {
        let reflectedLevel = self.reflectedVertically()
        return self.cellsMatrix == other.cellsMatrix
        || self.rotated90().cellsMatrix == other.cellsMatrix
        || self.rotated180().cellsMatrix == other.cellsMatrix
        || self.rotated270().cellsMatrix == other.cellsMatrix

        || reflectedLevel.cellsMatrix == other.cellsMatrix
        || reflectedLevel.rotated90().cellsMatrix == other.cellsMatrix
        || reflectedLevel.rotated180().cellsMatrix == other.cellsMatrix
        || reflectedLevel.rotated270().cellsMatrix == other.cellsMatrix
    }

    func rotated90() -> Level {
        let row = Array(repeating: 0, count: levelSize)
        var rotatedMatrix = Array(repeating: row, count: levelSize)

        for row in 0..<cellsMatrix.count {
            for col in 0..<cellsMatrix.count {
                rotatedMatrix[col][levelSize - 1 - row] = cellsMatrix[row][col]
            }
        }

        return Level(
            id: self.id,
            cellsMatrix: rotatedMatrix,
            status: self.status
        )
    }

    func rotated180() -> Level {
        self.rotated90().rotated90()
    }

    func rotated270() -> Level {
        self.rotated180().rotated90()
    }

    func reflectedVertically() -> Level {
        let row = Array(repeating: 0, count: levelSize)
        var reflectedMatrix = Array(repeating: row, count: levelSize)

        for row in 0..<cellsMatrix.count {
            for col in 0..<cellsMatrix.count {
                reflectedMatrix[row][levelSize - 1 - col] = cellsMatrix[row][col]
            }
        }

        return Level(
            id: self.id,
            cellsMatrix: reflectedMatrix,
            status: self.status
        )
    }
}

extension Level {
    static func == (lhs: Level, rhs: Level) -> Bool {
        if lhs.id == rhs.id
            && lhs.cellsMatrix == rhs.cellsMatrix
            && lhs.status == rhs.status {
            return true
        } else {
            return false
        }
    }
}
