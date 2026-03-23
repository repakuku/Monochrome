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

    func test_generateRandomLevel_withZeroSize_shouldReturnDefaultLevel() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: 0,
            existingLevels: []
        )

        XCTAssertEqual(level.id, 0, "Expected default level with id 0")
        XCTAssertEqual(level.cellsMatrix, [[0]], "Expected default matrix [[0]]")
    }

    func test_generateRandomLevel_withNegativeSize_shouldReturnDefaultLevel() {
        let level = sut.generateRandomLevel(
            id: 1,
            size: -5,
            existingLevels: []
        )

        XCTAssertEqual(level.id, 0, "Expected default level with id 0")
        XCTAssertEqual(level.cellsMatrix, [[0]], "Expected default matrix [[0]]")
    }

    func test_generateRandomLevel_shouldNotgenerateAlreadySolvedLevel() {
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

    func test_generateRandomLevel_shouldNotDuplicateExistinglevel() {
        let stubRandomSource = StubRandomSource(values: [0, 1, 1, 0, 1, 0, 0, 1])
        let existingLevel = Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])

        let level = sut.generateRandomLevel(
            id: 2,
            size: 2,
            existingLevels: [existingLevel],
            randomSource: stubRandomSource
        )

        XCTAssertNotEqual(
            level.cellsMatrix,
            existingLevel.cellsMatrix,
            "Expected generated level not to duplicate existing level"
        )
    }

    func test_generateRandomLevel_withAllLevelsExhausted_shouldReturnDefaultLevel() {
        var existingLevels: [Level] = []

        for index in 0..<15 {
            existingLevels.append(Level(id: index, cellsMatrix: [[0, 0], [0, 0]]))
        }

        let level = sut.generateRandomLevel(
            id: 15,
            size: 2,
            existingLevels: existingLevels
        )

        XCTAssertEqual(level.id, 0, "Expected default level when all variants exhausted")
        XCTAssertEqual(level.cellsMatrix, [[0]], "Expected default matrix [[0]]")
    }
}
