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

	// MARK: - Toggle Colors

	func test_toggleColors_shouldToggleCorrectly() {
		let sut = makeSut()

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
		let sut = makeSut()

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

	// MARK: - Check Matrix

	func test_checkMatrix_shouldReturnTrueForAllToggled() {
		let sut = makeSut()

		let testLevel = Level(
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
		let sut = makeSut()

		let testLevel = Level(
			id: 1,
			cellsMatrix: [
				[1, 0],
				[1, 1]
			]
		)

		let result = sut.checkMatrix(level: testLevel)

		XCTAssertFalse(result, "Expected checkMatrix to return false when not all cells are toggled to 1.")
	}

	// MARK: - Get Hint

	func test_getHint_shouldMarkHintCell() {
		let sut = makeSut()

		var testLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 1],
				[1, 0]
			]
		)

		sut.getHint(level: &testLevel)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 2, "Expected cell at (0, 0) to be marked as a hint.")

		sut.toggleColors(level: &testLevel, atX: 0, atY: 1)
		sut.getHint(level: &testLevel)

		XCTAssertEqual(testLevel.cellsMatrix[0][0], 3, "Expected cell at (0, 0) to be marked as a hint.")
	}

	// MARK: - Count Target Taps

	func test_countTargetTaps_shouldReturnCorrectTapsCount() {
		let sut = makeSut()

		let testLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 1],
				[1, 0]
			]
		)

		let targetTaps = sut.countTargetTaps(for: testLevel)
		let expectedTargetTaps = 2

		XCTAssertEqual(targetTaps, expectedTargetTaps, "Expected target taps count to be \(expectedTargetTaps) for solving the level.")
	}
}

private extension LevelServiceTests {
	func makeSut() -> LevelService {
		LevelService()
	}
}
