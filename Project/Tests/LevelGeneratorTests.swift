//
//  LevelGeneratorTests.swift
//  Monochrome
//
//  Created by Alexey Turulin on 3/13/26.
//  Copyright © 2026 com.repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class LevelGeneratorTests: XCTestCase {

    private var sut: ILevelGenerator! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()

        sut = LevelGenerator()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: Generate Random Level

    func test_generateRandomLevel_shouldReturnLevelWithCorrectId() {
        let level = sut.generateRandomLevel(
            id: 5,
            size: 3,
            existingLevels: []
        )

        XCTAssertEqual(level.id, 5, "Expected level id to be 5, but got \(level.id)")
    }

    func test_generateRandomLevel_shouldReturnLevelWithCorrectSize() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 4,
            existingLevels: []
        )

        XCTAssertEqual(level.levelSize, 4, "Expected level size to be 4, but got \(level.levelSize)")
        XCTAssertEqual(level.cellsMatrix.count, 4, "Expected matrix rows to be 4")
        XCTAssertEqual(level.cellsMatrix[0].count, 4, "Expected matrix columns to be 4")
    }

    func test_generateRandomLevel_shouldReturnSquareMatrix() {
        let sizes = [2, 4, 6]

        for size in sizes {
            let level = sut.generateRandomLevel(
                id: 0,
                size: size,
                existingLevels: []
            )

            XCTAssertEqual(level.cellsMatrix.count, size, "Expected \(size) rows")
            for row in level.cellsMatrix {
                XCTAssertEqual(row.count, size, "Expected \(size) columns in each row")
            }
        }
    }

    func test_generateRandomLevel_shouldContainOnlyZerosAndOnes() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 5,
            existingLevels: []
        )

        for row in level.cellsMatrix {
            for cell in row {
                XCTAssertTrue(cell == 0 || cell == 1, "Expected cell value to be 0 or 1, but got \(cell)")
            }
        }
    }

    func test_generateRandomLevel_shouldReturnIncompletedStatus() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 3,
            existingLevels: []
        )

        XCTAssertEqual(level.status, .incompleted, "Expected level status to be incompleted")
    }

    func test_generateRandomLevel_withOddSize_shouldRoundUpToEvenSize() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 3,
            existingLevels: []
        )

        XCTAssertEqual(level.levelSize, 4, "Expected size 3 to be rounded up to 4")
    }

    func test_generateRandomLevel_withSize1_shouldReturnMinimumSize2() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 1,
            existingLevels: []
        )

        XCTAssertEqual(level.levelSize, 2, "Expected size 1 to be rounded up to 2")
    }

    func test_generateRandomLevel_withZeroSize_shouldReturnFallbackLevelWithPassedId() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 0,
            existingLevels: []
        )

        XCTAssertEqual(level.id, 1, "Expected fallback level with id 1")
        XCTAssertEqual(level.cellsMatrix, [[0]], "Expected fallback matrix [[0]]")
    }

    func test_generateRandomLevel_withNegativeSize_shouldReturnFallbackLevelWithPassedId() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: -5,
            existingLevels: []
        )

        XCTAssertEqual(level.id, 1, "Expected fallback level with id 1")
        XCTAssertEqual(level.cellsMatrix, [[0]], "Expected fallback matrix [[0]]")
    }

    func test_generateRandomLevel_shouldNotGenerateAlreadySolvedLevel() {
        let stubRandomSource = StubRandomSource(values: [1, 1, 1, 1, 0, 1, 1, 0])
        let level = sut.generateRandomLevel(
            id: 1,
            size: 2,
            existingLevels: [],
            randomSource: stubRandomSource
        )

        let isSolved = level.cellsMatrix.allSatisfy { row in row.allSatisfy { $0 == 1 } }

        XCTAssertFalse(isSolved, "Expected generated level not to be already solved")
    }

    func test_generateRandomLevel_shouldNotGenerateLevelEquivalentToExistingLevel() {
        let stubRandomSource = StubRandomSource(
            values: [
                1, 1, 0, 1, // equivalent to existing level
                1, 0, 0, 0  // unique level
            ]
        )

        let existingLevel = Level(
            id: 1,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let generatedLevel = sut.generateRandomLevel(
            id: 2,
            size: 2,
            existingLevels: [existingLevel],
            randomSource: stubRandomSource
        )

        let expectedLevel = Level(
            id: 2,
            cellsMatrix: [
                [1, 0],
                [0, 0]
            ]
        )

        XCTAssertEqual(
            generatedLevel,
            expectedLevel,
            "Expected generator to skip level equivalent to existing one and return a unique level."
        )
    }

    func test_generateRandomLevel_withAllUniqueLevelsExhausted_shouldReturnFallbackLevelWithPassedId() {
        let existingLevels = [
            Level(id: 0, cellsMatrix: [
                [0, 0],
                [0, 0]
            ]),
            Level(id: 1, cellsMatrix: [
                [1, 0],
                [0, 0]
            ]),
            Level(id: 2, cellsMatrix: [
                [1, 1],
                [0, 0]
            ]),
            Level(id: 3, cellsMatrix: [
                [1, 0],
                [0, 1]
            ]),
            Level(id: 4, cellsMatrix: [
                [1, 1],
                [1, 0]
            ])
        ]

        let level = sut.generateRandomLevel(
            id: 5,
            size: 2,
            existingLevels: existingLevels
        )

        XCTAssertEqual(
            level.id,
            5,
            "Expected fallback level to keep passed id when all unique levels are exhausted."
        )
        XCTAssertEqual(level.cellsMatrix, [[0]], "Expected fallback matrix [[0]].")
    }

    func test_generateRandomLevel_shouldIgnoreLevelsOfDifferentSizeWhenCheckingExhaustion() {
        let stubRandomSource = StubRandomSource(
            values: [
                0, 1, 1, 1 // the missing 2x2 class: three ones
            ]
        )

        let existingLevels = [
            Level(id: 0, cellsMatrix: [[0]]), // tutorial 1x1, should be ignored
            Level(id: 1, cellsMatrix: [
                [0, 0],
                [0, 0]
            ]),
            Level(id: 2, cellsMatrix: [
                [1, 0],
                [0, 0]
            ]),
            Level(id: 3, cellsMatrix: [
                [1, 1],
                [0, 0]
            ]),
            Level(id: 4, cellsMatrix: [
                [1, 0],
                [0, 1]
            ])
        ]

        let generatedLevel = sut.generateRandomLevel(
            id: 6,
            size: 2,
            existingLevels: existingLevels,
            randomSource: stubRandomSource
        )

        let expectedLevel = Level(
            id: 6,
            cellsMatrix: [
                [0, 1],
                [1, 1]
            ]
        )

        XCTAssertEqual(
            generatedLevel,
            expectedLevel,
            "Expected generator to ignore levels of different size when checking exhaustion."
        )
    }

    func test_generateRandomLevel_shouldKeepTryingUntilItFindsRemainingUniqueLevel() {
        let duplicatePattern = [
            1, 0, 0, 0 // one filled cell, equivalent to existing level
        ]

        let uniquePattern = [
            0, 1, 1, 1 // three filled cells, unique in this setup
        ]

        let stubRandomSource = StubRandomSource(
            values:
                duplicatePattern +
                duplicatePattern +
                duplicatePattern +
                duplicatePattern +
                duplicatePattern +
                uniquePattern
        )

        let existingLevels = [
            Level(id: 0, cellsMatrix: [[0]]), // different size, should be ignored
            Level(id: 1, cellsMatrix: [
                [0, 0],
                [0, 0]
            ]),
            Level(id: 2, cellsMatrix: [
                [1, 0],
                [0, 0]
            ]),
            Level(id: 3, cellsMatrix: [
                [1, 1],
                [0, 0]
            ]),
            Level(id: 4, cellsMatrix: [
                [1, 0],
                [0, 1]
            ])
        ]

        let generatedLevel = sut.generateRandomLevel(
            id: 5,
            size: 2,
            existingLevels: existingLevels,
            randomSource: stubRandomSource
        )

        let expectedLevel = Level(
            id: 5,
            cellsMatrix: [
                [0, 1],
                [1, 1]
            ]
        )

        XCTAssertEqual(
            generatedLevel,
            expectedLevel,
            "Expected generator to keep trying until it finds the remaining unique level."
        )
    }
}
