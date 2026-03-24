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
            return fallbackLevel(id: id)
        }

        let normalizedSize = normalizedSize(from: size)

        guard !isGenerationExhausted(for: normalizedSize, existingLevels: existingLevels) else {
            return fallbackLevel(id: id)
        }

        guard let level = findValidLevel(
            id: id,
            size: normalizedSize,
            existingLevels: existingLevels,
            randomSource: randomSource
        ) else {
            return fallbackLevel(id: id)
        }

        return level
    }

    private func fallbackLevel(id: Int) -> Level {
        return Level(
            id: id,
            cellsMatrix: [[0]]
        )
    }

    private func normalizedSize(from size: Int) -> Int {
        let evenSize = size.isMultiple(of: 2) ? size : size + 1
        return max(2, evenSize)
    }

    private func pow2(_ exponent: Int) -> Int {
        Int(pow(2.0, Double(exponent)))
    }

    private func maxCandidateCount(for size: Int) -> Int {
        let n = size // swiftlint:disable:this identifier_name

        let identity = pow2(n * n)

        let rot90And270Exponent = n.isMultiple(of: 2)
            ? (n * n) / 4
            : (n * n + 3) / 4
        let rot90 = pow2(rot90And270Exponent)
        let rot270 = rot90

        let rot180Exponent = n.isMultiple(of: 2)
            ? (n * n) / 2
            : (n * n + 1) / 2
        let rot180 = pow2(rot180Exponent)

        let vertical = pow2(n * ((n + 1) / 2))
        let horizontal = vertical

        let mainDiagonal = pow2(n * (n + 1) / 2)
        let antiDiagonal = mainDiagonal

        let uniquePatterns = (
            identity +
            rot90 +
            rot180 +
            rot270 +
            vertical +
            horizontal +
            mainDiagonal +
            antiDiagonal
        ) / 8

        let solvedOrbitCount = 1

        return uniquePatterns - solvedOrbitCount
    }

    private func isGenerationExhausted(for size: Int, existingLevels: [Level]) -> Bool {
        let levelsWithSameSize = existingLevels.filter { $0.levelSize == size }
        return levelsWithSameSize.count >= maxCandidateCount(for: size)
    }

    private func generationAttemptLimit(for size: Int) -> Int {
        max(50, maxCandidateCount(for: size) * 10)
    }

    private func makeRandomLevel(
        id: Int,
        size: Int,
        randomSource: IRandomSource
    ) -> Level {
        let row = Array(repeating: 0, count: size)
        var cellsMatrix = Array(repeating: row, count: size)

        for row in 0..<size {
            for col in 0..<size {
                cellsMatrix[row][col] = randomSource.next()
            }
        }

        return Level(id: id, cellsMatrix: cellsMatrix)
    }

    private func isInvalidCandidate(
        _ level: Level,
        existingLevels: [Level]
    ) -> Bool {
        let levelsWithSameSize = existingLevels.filter { $0.levelSize == level.levelSize }

        return level.isCompleted || levelsWithSameSize.contains { $0.isEquivalent(to: level) }
    }

    private func findValidLevel(
        id: Int,
        size: Int,
        existingLevels: [Level],
        randomSource: IRandomSource
    ) -> Level? {
        let attemptLimit = generationAttemptLimit(for: size)

        for _ in 0..<attemptLimit {
            let candidate = makeRandomLevel(
                id: id,
                size: size,
                randomSource: randomSource
            )

            if !isInvalidCandidate(candidate, existingLevels: existingLevels) {
                return candidate
            }
        }

        return nil
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

        let normalizedSize = normalizedSize(from: size)

        let row = Array(repeating: 0, count: normalizedSize)
        var cellsMatrix = Array(repeating: row, count: normalizedSize)

        for row in 0..<normalizedSize {
            for col in 0..<normalizedSize {
                cellsMatrix[row][col] = (row + col) % 2
            }
        }

        return Level(id: id, cellsMatrix: cellsMatrix)
    }

    private func normalizedSize(from size: Int) -> Int {
        let evenSize = size.isMultiple(of: 2) ? size : size + 1
        return max(2, evenSize)
    }
}
