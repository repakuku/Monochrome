//
//  LevelGenerator.swift
//  Monochrome
//
//  Created by Alexey Turulin on 3/13/26.
//  Copyright © 2026 com.repakuku. All rights reserved.
//

import Foundation

protocol ILevelGenerator {
    func generateRandomLevel(
        id: Int,
        size: Int,
        existingLevels: [Level],
        randomSource: IRandomSource
    ) -> Level
}

final class LevelGenerator: ILevelGenerator {
    func generateRandomLevel(
        id: Int,
        size: Int,
        existingLevels: [Level],
        randomSource: IRandomSource = RandomSource()
    ) -> Level {
        guard id >= 0, size > 0 else {
            return Level(id: 0, cellsMatrix: [[0]])
        }

        var correctSize = size % 2 == 0 ? size : size + 1
        correctSize = max(2, correctSize)

        let maxAttempts = maxUniqueLevels(for: correctSize)

        guard existingLevels.count < maxAttempts else {
            return Level(id: 0, cellsMatrix: [[0]])
        }

        var level: Level
        var attempts = 0

        repeat {
            let row = Array(repeating: 0, count: correctSize)
            var cellsMatrix = Array(repeating: row, count: correctSize)

            for row in 0..<correctSize {
                for col in 0..<correctSize {
                    cellsMatrix[row][col] = randomSource.next()
                }
            }

            level = Level(id: id, cellsMatrix: cellsMatrix)

            attempts += 1
        } while attempts < maxAttempts
        && (level.isCompleted || existingLevels.contains { $0.cellsMatrix == level.cellsMatrix })

        return level
    }

    private func maxUniqueLevels(for size: Int) -> Int {
        Int(pow(2.0, Double(size * size))) - 1
    }
}

extension ILevelGenerator {
    func generateRandomLevel(id: Int, size: Int, existingLevels: [Level]) -> Level {
        generateRandomLevel(
            id: id,
            size: size,
            existingLevels: existingLevels,
            randomSource: RandomSource()
        )
    }
}

final class MockLevelGenerator: ILevelGenerator {

    var generateRandomLevelCalled = false

    var lastGeneratedId: Int?
    var lastGeneratedSize: Int?
    var lastExistingLevels: [Level]?

    func generateRandomLevel(
        id: Int,
        size: Int,
        existingLevels: [Level],
        randomSource: IRandomSource = RandomSource()
    ) -> Level {
        generateRandomLevelCalled = true
        lastGeneratedId = id
        lastGeneratedSize = size
        lastExistingLevels = existingLevels

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
