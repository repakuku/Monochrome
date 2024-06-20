//
//  GameManagerTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class GameManagerTests: XCTestCase {

	func test_init_shouldImplementCorrectInstance() {
		let sut = makeSut()

		let currentLevel = sut.level

		let expectedLevel = Level(
			id: 0,
			cellsMatrix: [[0]]
		)

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected initial level ID to be 0.")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected initial cells matrix to match.")
		XCTAssertEqual(currentLevel.status, .incompleted, "Expected initial level to not be completed.")
		XCTAssertEqual(sut.taps, 0, "Expected initial taps to be 0.")
	}

	func test_toggleColors_withValidData_shouldToggleColorsAndIncrementTaps() {
		let sut = makeSut()

		sut.toggleColors(atX: 0, atY: 0)

		let expectedMatrix = [[1]]
		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to toggle correctly when toggling at (0, 0).")
		XCTAssertEqual(sut.taps, 1, "Expected taps to increment to 1 after toggling colors.")
	}

	func test_toggleColors_withInvalidCoordinates_shouldNotChangeState() {
		let sut = makeSut()

		let initialMatrix = sut.level.cellsMatrix
		let initialTaps = sut.taps

		sut.toggleColors(atX: -1, atY: 0)
		XCTAssertEqual(sut.level.cellsMatrix, initialMatrix, "Expected cells matrix to remain unchanged for out-of-bounds coordinates.")
		XCTAssertEqual(sut.taps, initialTaps, "Expected taps to remain unchanged for out-of-bounds coordinates.")
	}

	func test_isLevelCompleted_shouldReturnTrueAfterCorrectToggle() {
		let sut = makeSut()

		XCTAssertFalse(sut.isLevelCompleted, "Expected level to be incomplete initially.")

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(sut.isLevelCompleted, "Expected level to be completed after toggling the correct cell.")

		sut.nextLevel()

		XCTAssertFalse(sut.isLevelCompleted, "Expected new level to be incomplete after advancing.")
	}

	func test_restartLevel_shouldResetStateToInitial() {
		let sut = makeSut()

		sut.toggleColors(atX: 0, atY: 0)
		sut.restartLevel()

		let expectedMatrix = [[0]]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to reset to initial state on restart.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 on restart.")
		XCTAssertFalse(sut.isLevelCompleted, "Expected level to not be completed after restart.")
	}

	func test_restartLevel_withMultipleActions_shouldResetToInitialState() {
		let sut = makeSut()

		sut.nextLevel()
		sut.toggleColors(atX: 0, atY: 0)
		sut.getHint()

		sut.restartLevel()

		let currentLevel = sut.level
		let expectedLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected to remain at the same level (ID 1) after restarting the level.")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to reset to initial state after restarting the level.")
		XCTAssertFalse(sut.isLevelCompleted, "Expected level to be incomplete after restarting.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 after restarting the level.")
	}

	func test_nextLevel_withValidState_shouldAdvanceToNextLevel() {
		let sut = makeSut()

		sut.nextLevel()

		let currentLevel = sut.level
		let expectedLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected to advance to level ID 1 after calling nextLevel.")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to match for level 1.")
		XCTAssertFalse(sut.isLevelCompleted, "Expected level to be incomplete after advancing to the next level.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 after advancing to the next level.")
	}

	func test_nextLevel_withLastLevel_shouldRemainAtLastLevel() {
		let sut = makeSut()

		for _ in 0...6 {
			sut.nextLevel()
		}

		let currentLevel = sut.level
		let expectedLevel = Level(
			id: 5,
			cellsMatrix: [
				[1, 1, 1, 1],
				[1, 0, 0, 1],
				[1, 0, 0, 1],
				[1, 1, 1, 1]
			]
		)

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected to remain at the last level (ID 2) after calling nextLevel at the last level.")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to match for the last level.")
		XCTAssertFalse(sut.isLevelCompleted, "Expected level to be incomplete when remaining at the last level.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 when remaining at the last level.")
	}

	func test_getHint_shouldProvideHintInMatrix() {
		let sut = makeSut()

		sut.nextLevel()
		sut.getHint()

		var expectedMatrix = [
			[0, 2],
			[1, 0]
		]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected hint to be shown in cells matrix.")

		sut.toggleColors(atX: 0, atY: 1)

		expectedMatrix = [
			[1, 1],
			[1, 1]
		]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to match after toggling hinted cell.")

		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 0)
		sut.getHint()

		expectedMatrix = [
			[3, 1],
			[0, 0]
		]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected hint to be shown in cells matrix after restart and toggle.")

		sut.toggleColors(atX: 0, atY: 0)

		expectedMatrix = [
			[0, 0],
			[1, 0]
		]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to match after clearing hint by toggling.")

		sut.getHint()
		sut.toggleColors(atX: 0, atY: 0)

		expectedMatrix = [
			[1, 1],
			[0, 0]
		]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to match after toggling hinted cell again.")
	}

	func test_getTapsForLevel_withCorrectId_shouldReturnCorrectTapsForCompletedlevel() {
		let sut = makeSut()

		// Initial state check for level 0
		var taps = sut.getTapsForLevel(id: 0)
		var expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected initial taps to be \(expectedTaps) for level 0.")

		// Perform a toggle action
		sut.toggleColors(atX: 0, atY: 0)
		taps = sut.getTapsForLevel(id: 0)
		expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be reset to \(expectedTaps) after restarting level 0.")

		// Move to next level
		sut.nextLevel()
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected initial taps to be \(expectedTaps) for level 1.")

		// Perform a toggle on level 1 but not completing it (assuming more toggles are needed)
		sut.toggleColors(atX: 0, atY: 0)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after one toggle at (0, 0) on level 1.")
	}

	func test_getTapsForLevel_withIncorrectId_shouldReturnCorrectTapsForCompletedlevel() {
		let sut = makeSut()

		let taps = sut.getTapsForLevel(id: -1)
		let expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID.")
	}

	func test_getTapsForLevel_afterReplay_shouldReturnBestResult() {
		let sut = makeSut()
		var taps = 0
		var expectedTaps = 0

		sut.nextLevel()

		// Perform toggle actions resulting in 3 taps
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 3

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after 3 toggles at (0,0), (0,0), and (0,1) on level 1.")

		// Restart level and complete with fewer taps (1 tap)
		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after 1 toggle at (0,1) on restarted level 1.")

		// Restart again and perform the same previous 3 toggles
		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after 3 toggles at (0,0), (0,0), and (0,1) on level 1.")

		// After replaying, the best result should still be 1
		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 1
		XCTAssertEqual(taps, expectedTaps, "Expected best taps to be \(expectedTaps) after 1 toggle at (0,1) on restarted level 1, reflecting the best result.")
	}

	func test_getStatusForLevel_withValidId_shouldReturnCorrectStatus() {
		let sut = makeSut()
		
		// Move to level 1
		sut.nextLevel()

		// Initially, the level should not be completed
		var status = sut.getStatusForLevel(id: 1)

		XCTAssertFalse(status, "Expected level 1 to be incompleted initially.")

		// Complete the level by toggling the necessary cells
		sut.toggleColors(atX: 0, atY: 1)

		// Now, the level should be completed
		status = sut.getStatusForLevel(id: 1)

		XCTAssertTrue(status, "Expected level 1 to be completed after toggling at (0,1).")

		// Restart the level to check if it resets the completion status
		sut.restartLevel()

		// The status should reflect the level's state (completed or incompleted) after restart
		status = sut.getStatusForLevel(id: 1)

		XCTAssertTrue(status, "Expected level 1 to be incompleted after restarting the level.")
	}

	func test_getStatusForLevel_withInvalidId_shouldReturnFalse() {
		let sut = makeSut()

		let status = sut.getStatusForLevel(id: -1)

		XCTAssertFalse(status, "Expected level status to be false for an invalid level ID.")
	}
}

extension GameManagerTests {
	func makeSut() -> GameManager {
		GameManager(
			levelRepository: LevelRepository(),
			levelService: LevelService()
		)
	}
}
