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
	
	func test_init_shouldImplementCorrectInstance() {
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

		let expectedAnswerMatrix = [
			[0, 1],
			[0, 0]
		]

		assertLevelProperties(
			sut,
			expectedId: 1, 
			expectedMatrix: expectedMatrix,
			expectedCompletedState: false,
			expectedAnswerMatrix: expectedAnswerMatrix,
			expectedTargetTaps: 1
		)
	}

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

		let expectedAnswerMatrix = [
			[0, 1],
			[0, 0]
		]

		assertLevelProperties(
			sut,
			expectedId: 1,
			expectedMatrix: expectedMatrix,
			expectedCompletedState: false,
			expectedAnswerMatrix: expectedAnswerMatrix,
			expectedTargetTaps: 1
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

		let expectedAnswerMatrix = [[1]]

		assertLevelProperties(
			sut,
			expectedId: 0,
			expectedMatrix: expectedMatrix,
			expectedCompletedState: false,
			expectedAnswerMatrix: expectedAnswerMatrix,
			expectedTargetTaps: 1
		)
	}

	func test_init_emptyMatrix_shouldReturnZeroLevel() {
		let sut = Level(
			id: 2,
			cellsMatrix: []
		)

		let expectedMatrix = [[0]]
		let expectedAnswerMatrix = [[1]]

		assertLevelProperties(
			sut,
			expectedId: 0,
			expectedMatrix: expectedMatrix,
			expectedCompletedState: false,
			expectedAnswerMatrix: expectedAnswerMatrix,
			expectedTargetTaps: 1
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

		let expectedAnswerMatrix = [[1]]

		assertLevelProperties(
			sut,
			expectedId: 0,
			expectedMatrix: expectedMatrix,
			expectedCompletedState: false,
			expectedAnswerMatrix: expectedAnswerMatrix,
			expectedTargetTaps: 1
		)
	}

	private func assertLevelProperties(
		_ level: Level,
		expectedId: Int,
		expectedMatrix: [[Int]],
		expectedCompletedState: Bool,
		expectedAnswerMatrix: [[Int]],
		expectedTargetTaps: Int,
		file: StaticString = #file,
		line: UInt = #line
	) {
		XCTAssertEqual(level.id, expectedId, "Expected level ID to be \(expectedId).", file: file, line: line)
		XCTAssertEqual(level.cellsMatrix, expectedMatrix, "Expected cells matrix to match.", file: file, line: line)
		XCTAssertEqual(level.isCompleted, expectedCompletedState, "Expected isCompleted to be \(expectedCompletedState).", file: file, line: line)
		XCTAssertEqual(level.levelSize, expectedMatrix.count, "Expected level size to be \(expectedMatrix.count).", file: file, line: line)
		XCTAssertEqual(level.answerMatrix, expectedAnswerMatrix, "Expected answer matrix to match.", file: file, line: line)
		XCTAssertEqual(level.targetTaps, expectedTargetTaps, "Expected target taps to be \(expectedTargetTaps).", file: file, line: line)
	}
}
