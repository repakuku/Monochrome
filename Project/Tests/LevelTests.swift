//
//  LevelTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/15/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class LevelTests: XCTestCase {

    // MARK: init

	func test_init_incompletedLevel_shouldImplementCorrectInstance() {
		let sut = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		let expectedMatrix = [
			[0, 0],
			[1, 0]
		]

		assertLevelProperties(
			sut,
			expectedId: 1,
			expectedMatrix: expectedMatrix,
			expectedStatus: .incompleted
		)
	}

	func test_init_completedLevel_shouldImplementCorrectInstance() {
		let sut = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			],
			status: .completed(2)
		)

		let expectedMatrix = [
			[0, 0],
			[1, 0]
		]

		assertLevelProperties(
			sut,
			expectedId: 1,
			expectedMatrix: expectedMatrix,
			expectedStatus: .completed(2)
		)
	}

	func test_init_negativeId_shouldReturnZeroLevel() {
		let sut = Level(
			id: -1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		let expectedMatrix = [[0]]

		assertLevelProperties(
			sut,
			expectedId: 0,
			expectedMatrix: expectedMatrix,
			expectedStatus: .incompleted
		)
	}

	func test_init_emptyMatrix_shouldReturnZeroLevel() {
		let sut = Level(
			id: 2,
			cellsMatrix: []
		)

		let expectedMatrix = [[0]]

		assertLevelProperties(
			sut,
			expectedId: 0,
			expectedMatrix: expectedMatrix,
			expectedStatus: .incompleted
		)
	}

	func test_init_irregularMatrix_shouldReturnZeroLevel() {
		let sut = Level(
			id: 3,
			cellsMatrix: [
				[0, 0, 1],
				[1, 0]
			]
		)

		let expectedMatrix = [[0]]

		assertLevelProperties(
			sut,
			expectedId: 0,
			expectedMatrix: expectedMatrix,
			expectedStatus: .incompleted
		)
	}

    // MARK: isEquivalent

    func test_isEquivalent_shouldReturnTrueForLevelsWithSameMatrix() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let same = Level(
            id: 1,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ],
            status: .completed(2)
        )

        let result = original.isEquivalent(to: same)

        XCTAssertTrue(result, "Expected levels to be equivalent.")
    }

    func test_isEquivalent_shouldReturnFalseForDifferentLevels() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let different = Level(
            id: 1,
            cellsMatrix: [
                [0, 1],
                [1, 0]
            ]
        )

        let result = original.isEquivalent(to: different)

        XCTAssertFalse(result, "Expected levels to be not equivalent.")
    }

    func test_isEquivalent_shouldReturnTrueForRotated90DegreesLevel() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let rotated = Level(
            id: 1,
            cellsMatrix: [
                [1, 1],
                [0, 1]
            ]
        )

        let result = original.isEquivalent(to: rotated)

        XCTAssertTrue(result, "Expected levels to be equivalent under 90 degree rotation")
    }

    func test_isEquivalent_shouldReturnTrueForRotated180DegreesLevel() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let rotated = Level(
            id: 1,
            cellsMatrix: [
                [0, 1],
                [1, 1]
            ]
        )

        let result = original.isEquivalent(to: rotated)

        XCTAssertTrue(result, "Expected levels to be equivalent under 180 degree rotation")
    }

    func test_isEquivalent_shouldReturnTrueForRotated270DegreesLevel() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let rotated = Level(
            id: 1,
            cellsMatrix: [
                [1, 0],
                [1, 1]
            ]
        )

        let result = original.isEquivalent(to: rotated)

        XCTAssertTrue(result, "Expected levels to be equivalent under 270 degree rotation")
    }

    func test_isEquivalent_shouldReturnTrueForReflectedLevel() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 0],
                [1, 1]
            ]
        )

        let reflected = Level(
            id: 0,
            cellsMatrix: [
                [0, 1],
                [1, 1]
            ]
        )

        let result = original.isEquivalent(to: reflected)

        XCTAssertTrue(result, "Expected levels to be equivalent under reflection")
    }

    // MARK: rotated90

    func test_rotated90_shouldReturnLevelRotatedBy90Degrees() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let rotated = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [0, 1]
            ]
        )

        let sut = original.rotated90()

        XCTAssertEqual(sut, rotated, "Expected level rotated by 90 degrees to match expected level.")
    }

    // MARK: rotated180

    func test_rotated180_shouldReturnLevelRotatedBy180Degrees() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let rotated = Level(
            id: 0,
            cellsMatrix: [
                [0, 1],
                [1, 1]
            ]
        )

        let sut = original.rotated180()

        XCTAssertEqual(sut, rotated, "Expected level rotated by 180 degrees to match expected level.")
    }

    // MARK: rotated270

    func test_rotated270_shouldReturnLevelRotatedBy270Degrees() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1],
                [1, 0]
            ]
        )

        let rotated = Level(
            id: 0,
            cellsMatrix: [
                [1, 0],
                [1, 1]
            ]
        )

        let sut = original.rotated270()

        XCTAssertEqual(sut, rotated, "Expected level rotated by 270 degrees to match expected level.")
    }

    // MARK: reflectedVertically

    func test_reflectedVertically_shouldReturnReflectedVerticallyLevel() {
        let original = Level(
            id: 0,
            cellsMatrix: [
                [1, 1, 0, 0],
                [1, 1, 1, 0],
                [0, 0, 0, 1],
                [1, 0, 1, 0]
            ]
        )

        let reflected = Level(
            id: 0,
            cellsMatrix: [
                [0, 0, 1, 1],
                [0, 1, 1, 1],
                [1, 0, 0, 0],
                [0, 1, 0, 1]
            ]
        )

        let sut = original.reflectedVertically()

        XCTAssertEqual(sut, reflected, "Expected level reflected vertically to match expected level.")
    }
}

private extension LevelTests {
	func assertLevelProperties(
		_ level: Level,
		expectedId: Int,
		expectedMatrix: [[Int]],
		expectedStatus: LevelStatus,
		file: StaticString = #file,
		line: UInt = #line
	) {
		XCTAssertEqual(level.id, expectedId, "Expected level ID to be \(expectedId).", file: file, line: line)
		XCTAssertEqual(level.cellsMatrix, expectedMatrix, "Expected cells matrix to match.", file: file, line: line)
		XCTAssertEqual(level.status, expectedStatus, "Expected status to be \(expectedStatus).", file: file, line: line)
		XCTAssertEqual(
			level.levelSize,
			expectedMatrix.count,
			"Expected level size to be \(expectedMatrix.count).",
			file: file,
			line: line
		)
	}
}
