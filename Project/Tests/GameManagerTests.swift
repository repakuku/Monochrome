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

	// MARK: - Initialization

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
		XCTAssertEqual(sut.level.status, expectedLevel.status, "Expected initial level to not be completed.")
	}

	// MARK: - Toggle Colors

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

	// MARK: - isLevelCompleted

	func test_isLevelCompleted_shouldReturnTrueAfterCorrectToggle() {
		let sut = makeSut()

		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete initially.")

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(sut.level.status, .completed(1), "Expected level to be completed after toggling the correct cell.")

		sut.nextLevel()

		XCTAssertEqual(sut.level.status, .incompleted, "Expected new level to be incomplete after advancing.")
	}

	// MARK: - Restart Level

	func test_restartLevel_shouldResetStateToInitial() {
		let sut = makeSut()

		sut.toggleColors(atX: 0, atY: 0)
		sut.restartLevel()

		let expectedMatrix = [[0]]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to reset to initial state on restart.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 on restart.")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to not be completed after restart.")
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
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete after restarting.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 after restarting the level.")
	}

	// MARK: - Next level

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
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete after advancing to the next level.")
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
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete when remaining at the last level.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0 when remaining at the last level.")
	}

	// MARK: - Get Hint

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

	// MARK: - Get Taps For Level

	func test_getTapsForLevel_withCorrectId_shouldReturnCorrectTapsForCompletedlevel() {
		let sut = makeSut()

		var taps = sut.getTapsForLevel(id: 0)
		var expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected initial taps to be \(expectedTaps) for level 0.")

		sut.toggleColors(atX: 0, atY: 0)
		taps = sut.getTapsForLevel(id: 0)
		expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be reset to \(expectedTaps) after restarting level 0.")

		sut.nextLevel()
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected initial taps to be \(expectedTaps) for level 1.")

		sut.toggleColors(atX: 0, atY: 0)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after one toggle at (0, 0) on level 1.")
	}

	func test_getTapsForLevel_withIncorrectId_shouldReturnCorrectTapsForCompletedlevel() {
		let sut = makeSut()

		var taps = sut.getTapsForLevel(id: -1)
		let expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID.")

		taps = sut.getTapsForLevel(id: Int.max)

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID.")
	}

	func test_getTapsForLevel_afterReplay_shouldReturnBestResult() {
		let sut = makeSut()
		var taps = 0
		var expectedTaps = 0

		sut.nextLevel()

		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 3

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after 3 toggles at (0,0), (0,0), and (0,1) on level 1.")

		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after 1 toggle at (0,1) on restarted level 1.")

		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) after 3 toggles at (0,0), (0,0), and (0,1) on level 1.")

		sut.restartLevel()
		sut.toggleColors(atX: 0, atY: 1)
		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 1
		XCTAssertEqual(taps, expectedTaps, "Expected best taps to be \(expectedTaps) after 1 toggle at (0,1) on restarted level 1, reflecting the best result.")
	}

	// MARK: - Get Status For Level

	func test_getStatusForLevel_withValidId_shouldReturnCorrectStatus() {
		let sut = makeSut()

		sut.nextLevel()

		var status = sut.getStatusForLevel(id: 1)

		XCTAssertFalse(status, "Expected level 1 to be incompleted initially.")

		sut.toggleColors(atX: 0, atY: 1)

		status = sut.getStatusForLevel(id: 1)

		XCTAssertTrue(status, "Expected level 1 to be completed after toggling at (0,1).")

		sut.restartLevel()
		status = sut.getStatusForLevel(id: 1)

		XCTAssertTrue(status, "Expected level 1 to be incompleted after restarting the level.")
	}

	func test_getStatusForLevel_withInvalidId_shouldReturnFalse() {
		let sut = makeSut()

		var status = sut.getStatusForLevel(id: -1)

		XCTAssertFalse(status, "Expected level status to be false for an invalid level ID.")

		status = sut.getStatusForLevel(id: Int.max)

		XCTAssertFalse(status, "Expected level status to be false for an invalid level ID.")
	}

	// MARK: - Get Stars For Level

	func test_getStarsForLevel_forInitialLevel_shouldReturnZeroStars() {
		let sut = makeSut()

		moveToLevel(sut, level: 5)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 0

		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 initially.")
	}

	func test_getStarsForLevel_withHighNumberOfTaps_ShouldReturnOneStar() {
		let sut = makeSut()

		moveToLevel(sut, level: 5)

		performToggles(
			sut: sut,
			toggles: [
			(0, 0),
			(0, 0),
			(0, 0),
			(0, 0),
			(0, 0),
			(0, 0),
			(1, 1),
			(1, 2),
			(2, 1),
			(2, 2)
		]
		)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 1

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with high number of taps.")
	}

	func test_getStarsForLevel_withModerateNumberOfTaps_ShouldReturnTwoStars() {
		let sut = makeSut()

		moveToLevel(sut, level: 5)

		performToggles(
			sut: sut,
			toggles: [
				(0, 0),
				(0, 0),
				(1, 1),
				(1, 2),
				(2, 1),
				(2, 2)
			]
		)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with moderate number of taps.")
	}

	func test_getStarsForLevel_withMinimalNumberOfTaps_ShouldReturnThreeStars() {
		let sut = makeSut()

		moveToLevel(sut, level: 5)

		performToggles(
			sut: sut,
			toggles: [
				(1, 1),
				(1, 2),
				(2, 1),
				(2, 2)
			]
		)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps.")
	}

	func test_getStarsForLevel_forCurrentGame_ShouldReturnActualNumberOfStars() {
		let sut = makeSut()

		moveToLevel(sut, level: 5)

		performToggles(
			sut: sut,
			toggles: [
				(1, 1),
				(1, 2),
				(2, 1),
				(2, 2)
			]
		)

		var stars = sut.getStarsForLevel(id: 5)
		var expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps.")

		sut.restartLevel()

		performToggles(
			sut: sut,
			toggles: [
				(0, 0),
				(0, 0),
				(0, 0),
				(0, 0),
				(1, 1),
				(1, 2),
				(2, 1),
				(2, 2)
			]
		)

		stars = sut.getStarsForLevel(id: 5, forCurrentGame: true)
		expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 after replay.")
	}

	func test_getStarsForLevel_forBestGame_ShouldReturnBestNumberOfStars() {
		let sut = makeSut()

		moveToLevel(sut, level: 5)

		performToggles(
			sut: sut,
			toggles: [
				(1, 1),
				(1, 2),
				(2, 1),
				(2, 2)
			]
		)

		var stars = sut.getStarsForLevel(id: 5)
		var expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps.")

		sut.restartLevel()

		performToggles(
			sut: sut,
			toggles: [
				(0, 0),
				(0, 0),
				(0, 0),
				(0, 0),
				(1, 1),
				(1, 2),
				(2, 1),
				(2, 2)
			]
		)

		stars = sut.getStarsForLevel(id: 5)
		expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 after replay.")
	}

	func test_getStarsForLevel_withInvalidId_ShouldReturnZeroStars() {
		let sut = makeSut()

		var stars = sut.getStarsForLevel(id: -1)
		let expectedStars = 0

		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for an invalid level ID.")

		stars = sut.getStarsForLevel(id: Int.max)

		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for an invalid level ID.")
	}

	// MARK: - Select Level

	func test_selectLevel_ShouldReturnSelectedLevel() {
		let sut = makeSut()

		sut.nextLevel()
		sut.toggleColors(atX: 0, atY: 1)

		sut.selectLevel(id: 5)

		let level = sut.level
		let expectedLevel = Level(
			id: 5,
			cellsMatrix: [
				[1, 1, 1, 1],
				[1, 0, 0, 1],
				[1, 0, 0, 1],
				[1, 1, 1, 1]
			]
		)

		XCTAssertEqual(level.id, expectedLevel.id, "Expected level ID to be \(expectedLevel.id).")
		XCTAssertEqual(level.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to match.")
		XCTAssertEqual(sut.taps, 0, "Expected taps to be reset to 0 after selecting a new level.")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete after selecting.")
	}

	func test_selectLevel_withInvalidId_ShouldReturnCurrentLevel() {
		let sut = makeSut()

		let expectedLevel = sut.level

		sut.selectLevel(id: -1)

		var level = sut.level

		XCTAssertEqual(level.id, expectedLevel.id)
		XCTAssertEqual(level.cellsMatrix, expectedLevel.cellsMatrix)

		sut.selectLevel(id: Int.max)

		level = sut.level

		XCTAssertEqual(level.id, expectedLevel.id)
		XCTAssertEqual(level.cellsMatrix, expectedLevel.cellsMatrix)
	}
}

private extension GameManagerTests {
	func makeSut() -> GameManager {
		GameManager(
			levelRepository: LevelRepository(
				levelsJsonUrl: Endpoints.levelsJsonUrl
			),
			levelService: LevelService()
		)
	}

	func moveToLevel(_ sut: GameManager, level: Int) {
		for _ in 0..<level {
			sut.nextLevel()
		}
	}

	func performToggles(sut: GameManager, toggles: [(Int, Int)]) {
		for (x, y) in toggles {
			sut.toggleColors(atX: x, atY: y)
		}
	}
}
