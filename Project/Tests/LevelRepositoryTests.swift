//
//  LevelRepositoryTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/15/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class LevelRepositoryTests: XCTestCase {

	func test_init_shouldReturnCorrectInstance() {
		let sut = LevelRepository()

		XCTAssertEqual(sut.count, 6, "Expected LevelRepository to initialize with 6 levels.")
	}

	func test_getLevels_shouldReturnCorrectLevels() {
		let sut = LevelRepository()
		let levels = sut.getLevels()

		XCTAssertEqual(levels.count, sut.count, "Expected getLevels to return the same number of levels as the repository count.")

		let expectedLevels = [
			Level(id: 0, cellsMatrix: [[0]]),
			Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
			Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
			Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
			Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
			Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
		]

		for (index, level) in levels.enumerated() {
			XCTAssertEqual(level.id, expectedLevels[index].id, "Expected level ID to be \(expectedLevels[index].id) at index \(index).")
			XCTAssertEqual(level.cellsMatrix, expectedLevels[index].cellsMatrix, "Expected cells matrix to match for level at index \(index).")
			XCTAssertEqual(level.status, .incompleted, "Expected new levels to be not completed by default.")
		}
	}
}
