//
//  LevelServiceTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/20/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class LevelServiceTests: XCTestCase {

	var sut: LevelService!

	override func setUp() {
		super.setUp()
		sut = LevelService()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func test_toggleColors_shouldToggleCorrectly() {
		var testLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 1],
				[1, 0]
			]
		)

		let expectedMatrix = [
			[1, 0],
			[0, 0]
		]

		sut.toggleColors(level: &testLevel, atX: 0, atY: 0)

		XCTAssertEqual(testLevel.cellsMatrix, expectedMatrix, "Expected cells matrix to toggle correctly when toggling at (0, 0).")
	}

	func test_toggleColors_shouldClearHintMarkers() {

		var testLevel = Level(
			id: 1,
			cellsMatrix: [
				[2, 1],
				[1, 0]
			]
		)

		sut.toggleColors(level: &testLevel, atX: 0, atY: 0)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 1, "Expected hint marker to be cleared and cell to be toggled.")

		testLevel = Level(
			id: 1,
			cellsMatrix: [
				[3, 1],
				[1, 0]
			]
		)

		sut.toggleColors(level: &testLevel, atX: 0, atY: 0)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 0, "Expected hint marker to be cleared and cell to be toggled.")

		testLevel = Level(
			id: 1,
			cellsMatrix: [
				[2, 1],
				[1, 0]
			]
		)

		sut.toggleColors(level: &testLevel, atX: 0, atY: 1)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 1, "Expected hint marker to be cleared and cell to be toggled.")

		testLevel = Level(
			id: 1,
			cellsMatrix: [
				[3, 1],
				[1, 0]
			]
		)

		sut.toggleColors(level: &testLevel, atX: 0, atY: 1)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 0, "Expected hint marker to be cleared and cell to be toggled.")

		testLevel = Level(
			id: 1,
			cellsMatrix: [
				[2, 1],
				[1, 0]
			]
		)

		sut.toggleColors(level: &testLevel, atX: 1, atY: 1)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 0, "Expected hint marker to be cleared and cell to remain untoggled.")

		testLevel = Level(
			id: 1,
			cellsMatrix: [
				[3, 1],
				[1, 0]
			]
		)

		sut.toggleColors(level: &testLevel, atX: 1, atY: 1)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 1, "Expected hint marker to be cleared and cell to remain untoggled.")
	}

	func test_checkMatrix_shouldReturnTrueForAllToggled() {
		var testLevel = Level(
			id: 1,
			cellsMatrix: [
				[1, 1],
				[1, 1]
			]
		)

		let result = sut.checkMatrix(level: testLevel)

		XCTAssertTrue(result, "Expected checkMatrix to return true when all cells are toggled to 1.")
	}

	func test_checkMatrix_shouldReturnFalseForUntoggledCells() {
		var testLevel = Level(
			id: 1,
			cellsMatrix: [
				[1, 0],
				[1, 1]
			]
		)

		let result = sut.checkMatrix(level: testLevel)

		XCTAssertFalse(result, "Expected checkMatrix to return false when not all cells are toggled to 1.")
	}

	func test_getHint_shouldMarkHintCell() {
		var testLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 1],
				[1, 0]
			]
		)

		sut.getHint(level: &testLevel)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 2, "Expected cell at (0, 1) to be marked as a hint.")
	}
}
