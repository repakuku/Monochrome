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

	private var mockLevelService: MockLevelService!
	private var stubLevelRepository: StubLevelRepository!

	private var sut: GameManager!

	override func setUp() {
		super.setUp()

		mockLevelService = MockLevelService()
		stubLevelRepository = StubLevelRepository()

		sut = GameManager(
			levelRepository: stubLevelRepository,
			levelService: mockLevelService
		)
	}

	override func tearDown() {
		mockLevelService = nil
		stubLevelRepository = nil

		sut = nil

		super.tearDown()
	}

	// MARK: - Initialization

	func test_init_shouldImplementCorrectInstance() {

		let currentLevel = sut.level
		let expectedLevel = Level(
			id: 0,
			cellsMatrix: [[0]]
		)

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected initial level ID to be 0, but got \(currentLevel.id).")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected initial cells matrix to match, but got \(currentLevel.cellsMatrix).")
		XCTAssertEqual(currentLevel.status, .incompleted, "Expected initial level to not be completed, but got \(currentLevel.status).")
		XCTAssertEqual(sut.taps, 0, "Expected initial taps to be 0, but got \(sut.taps).")
		XCTAssertEqual(sut.level.status, expectedLevel.status, "Expected initial level to not be completed, but got \(sut.level.status).")	}

	// MARK: - Toggle Colors

	func test_toggleColors_withValidData_shouldCallToggleColorsAndIncrementTaps() {

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(mockLevelService.toggleColorsCalled, "Expected toggleColors to be called, but it wasn't.")
		XCTAssertEqual(sut.taps, 1, "Expected taps to be 1, but got \(sut.taps).")
	}

	func test_toggleColors_withInvalidCoordinates_shouldNotCalltoggleColors() {

		sut.toggleColors(atX: -1, atY: 0)

		XCTAssertFalse(mockLevelService.toggleColorsCalled, "Expected toggleColors not to be called for invalid coordinates, but it was.")
	}

	func test_toggleColors_shouldCompleteTheLevelAndSaveTheBestResult() {
		mockLevelService.checkMatrixResult = true

		let levelId = sut.level.id

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(sut.level.status, .completed(1), "Expected level to be completed with 1 tap, but got \(sut.level.status).")

		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(sut.level.status, .completed(3), "Expected level to be completed with 3 taps, but got \(sut.level.status).")
		XCTAssertEqual(sut.levels[levelId].status, .completed(1), "Expected best result to be 1 tap, but got \(sut.levels[levelId].status).")
	}

	// MARK: - isLevelCompleted

	func test_isLevelCompleted_shouldReturnFalseForInitialStatus() {
		XCTAssertFalse(sut.getStatusForLevel(id: 0), "Expected initial status to be incompleted, but it wasn't.")
	}

	func test_isLevelCompleted_shouldReturnTrueAfterCorrectToggle() {

		mockLevelService.checkMatrixResult = true

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(sut.getStatusForLevel(id: 0), "Expected level to be completed, but it wasn't.")
	}

	// MARK: - Next level

	func test_nextLevel_shouldAdvanceToNextLevel() {

		sut.nextLevel()

		let currentLevel = sut.level
		let expectedLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected to advance to level ID 1, but got \(currentLevel.id).")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to match for level 1, but got \(currentLevel.cellsMatrix).")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete after advancing, but got \(sut.level.status).")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0, but got \(sut.taps).")
	}

	func test_nextLevel_forLastLevel_shouldRemainAtLastLevel() {

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

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected to remain at the last level (ID 5), but got \(currentLevel.id).")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to match for the last level, but got \(currentLevel.cellsMatrix).")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete, but got \(sut.level.status).")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0, but got \(sut.taps).")
	}

	// MARK: - Restart Level

	func test_restartLevel_shouldResetStateToInitial() {

		sut.toggleColors(atX: 0, atY: 0)
		sut.restartLevel()

		let expectedMatrix = [[0]]

		XCTAssertEqual(sut.level.cellsMatrix, expectedMatrix, "Expected cells matrix to reset to initial state, but got \(sut.level.cellsMatrix).")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0, but got \(sut.taps).")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to not be completed, but got \(sut.level.status).")
	}

	func test_restartLevel_withMultipleActions_shouldResetToInitialState() {

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

		XCTAssertEqual(currentLevel.id, expectedLevel.id, "Expected to remain at the same level (ID 1), but got \(currentLevel.id).")
		XCTAssertEqual(currentLevel.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to reset to initial state, but got \(currentLevel.cellsMatrix).")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete, but got \(sut.level.status).")
		XCTAssertEqual(sut.taps, 0, "Expected taps to reset to 0, but got \(sut.taps).")
	}

	// MARK: - Select Level

	func test_selectLevel_ShouldReturnSelectedLevel() {

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

		XCTAssertEqual(level.id, expectedLevel.id, "Expected level ID to be \(expectedLevel.id), but got \(level.id).")
		XCTAssertEqual(level.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to match, but got \(level.cellsMatrix).")
		XCTAssertEqual(sut.taps, 0, "Expected taps to be reset to 0, but got \(sut.taps).")
		XCTAssertEqual(sut.level.status, .incompleted, "Expected level to be incomplete, but got \(sut.level.status).")
	}

	func test_selectLevel_withInvalidId_ShouldReturnCurrentLevel() {

		let expectedLevel = sut.level

		sut.selectLevel(id: -1)

		var level = sut.level

		XCTAssertEqual(level.id, expectedLevel.id, "Expected level ID to remain \(expectedLevel.id), but got \(level.id).")
		XCTAssertEqual(level.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to remain the same, but got \(level.cellsMatrix).")

		sut.selectLevel(id: Int.max)

		level = sut.level

		XCTAssertEqual(level.id, expectedLevel.id, "Expected level ID to remain \(expectedLevel.id), but got \(level.id).")
		XCTAssertEqual(level.cellsMatrix, expectedLevel.cellsMatrix, "Expected cells matrix to remain the same, but got \(level.cellsMatrix).")
	}

	// MARK: - Get Hint

	func test_getHint_shouldProvideHintInMatrix() {

		sut.getHint()

		XCTAssertTrue(mockLevelService.getHintCalled, "Expected getHint to be called, but it wasn't.")
	}

	// MARK: - Get Taps For Level

	func test_getTapsForLevel_withCorrectId_shouldReturnCorrectTapsForCompletedlevel() {

		sut.levels[1].status = .completed(5)

		var taps = sut.getTapsForLevel(id: 0)
		var expectedTaps = 0

		XCTAssertEqual(taps, 0, "Expected initial taps to be \(expectedTaps) for level 0, but got \(taps).")

		taps = sut.getTapsForLevel(id: 1)
		expectedTaps = 5

		XCTAssertEqual(taps, 5, "Expected taps to be \(expectedTaps) for level 1, but got \(taps).")
	}

	func test_getTapsForLevel_withIncorrectId_shouldReturnCorrectTapsForCompletedlevel() {

		var taps = sut.getTapsForLevel(id: -1)
		let expectedTaps = 0

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID, but got \(taps).")

		taps = sut.getTapsForLevel(id: Int.max)

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID, but got \(taps).")
	}

	// MARK: - Get Status For Level

	func test_getStatusForLevel_withValidId_shouldReturnCorrectStatus() {

		var status = sut.getStatusForLevel(id: 1)

		XCTAssertFalse(status, "Expected level 1 to be incompleted initially, but it wasn't.")

		sut.levels[1].status = .completed(2)

		status = sut.getStatusForLevel(id: 1)

		XCTAssertTrue(status, "Expected level 1 to be completed, but it wasn't.")
	}

	func test_getStatusForLevel_withInvalidId_shouldReturnFalse() {

		var status = sut.getStatusForLevel(id: -1)

		XCTAssertFalse(status, "Expected level status to be false for an invalid level ID, but it wasn't.")

		status = sut.getStatusForLevel(id: Int.max)

		XCTAssertFalse(status, "Expected level status to be false for an invalid level ID, but it wasn't.")
	}

	// MARK: - Get Stars For Level

	func test_getStarsForLevel_forInitialLevel_shouldReturnZeroStars() {

		mockLevelService.countTargetTapsResult = 4

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 0

		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 initially, but got \(stars).")
	}

	func test_getStarsForLevel_withHighNumberOfTaps_ShouldReturnOneStar() {

		mockLevelService.countTargetTapsResult = 4
		sut.levels[5].status = .completed(10)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 1

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with high number of taps, but got \(stars).")
	}

	func test_getStarsForLevel_withModerateNumberOfTaps_ShouldReturnTwoStars() {
		
		mockLevelService.countTargetTapsResult = 4
		sut.levels[5].status = .completed(6)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with moderate number of taps, but got \(stars).")
	}

	func test_getStarsForLevel_withMinimalNumberOfTaps_ShouldReturnThreeStars() {
		
		mockLevelService.countTargetTapsResult = 4
		sut.levels[5].status = .completed(4)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps, but got \(stars).")
	}

	func test_getStarsForLevel_forCurrentGame_ShouldReturnActualNumberOfStars() {

		mockLevelService.countTargetTapsResult = 4
		sut.taps = 8
		sut.levels[5].status = .completed(4)

		var stars = sut.getStarsForLevel(id: 5)
		var expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps, but got \(stars).")

		stars = sut.getStarsForLevel(id: 5, forCurrentGame: true)
		expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 after replay, but got \(stars).")
	}

	func test_getStarsForLevel_withInvalidId_ShouldReturnZeroStars() {

		var stars = sut.getStarsForLevel(id: -1)
		let expectedStars = 0

		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for an invalid level ID, but got \(stars).")

		stars = sut.getStarsForLevel(id: Int.max)

		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for an invalid level ID, but got \(stars).")
	}
}
