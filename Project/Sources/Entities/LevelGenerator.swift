//
//  LevelGenerator.swift
//  Monochrome
//
//  Created by Alexey Turulin on 3/13/26.
//  Copyright © 2026 com.repakuku. All rights reserved.
//

import Foundation

protocol ILevelGenerator {
    func generateRandomLevel(id: Int, size: Int) -> Level
}

final class LevelGenerator: ILevelGenerator {
    func generateRandomLevel(id: Int, size: Int) -> Level {
        guard id >= 0, size > 0 else {
            return Level(id: 0, cellsMatrix: [[0]])
        }

        var correctSize = size % 2 == 0 ? size : size + 1
        correctSize = max(2, correctSize)

        let row = Array(repeating: 0, count: correctSize)
        var cellsMatrix = Array(repeating: row, count: correctSize)

        for row in 0..<correctSize {
            for col in 0..<correctSize {
                cellsMatrix[row][col] = Int.random(in: 0...1)
            }
        }

        let level = Level(id: id, cellsMatrix: cellsMatrix)

        return level
    }
}

final class MockLevelGenerator: ILevelGenerator {

    var generateRandomLevelCalled = false

    var lastGeneratedId: Int?
    var lastGeneratedSize: Int?

    func generateRandomLevel(id: Int, size: Int) -> Level {
        generateRandomLevelCalled = true
        lastGeneratedId = id
        lastGeneratedSize = size

        var correctSize = size % 2 == 0 ? size : size + 1
        correctSize = max(2, correctSize)

        let row = Array(repeating: 0, count: correctSize)
        var cellsMatrix = Array(repeating: row, count: correctSize)

        for row in 0..<correctSize {
            for col in 0..<correctSize {
                cellsMatrix[row][col] = (row + col) % 2
            }
        }

        return Level(id: id, cellsMatrix: cellsMatrix)
    }
}
