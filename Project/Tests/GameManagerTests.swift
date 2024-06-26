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
	private var stubGameRepository: StubGameRepository!

	private var sut: GameManager!

	override func setUp() {
		super.setUp()

		mockLevelService = MockLevelService()
		stubLevelRepository = StubLevelRepository()
		stubGameRepository = StubGameRepository()

		sut = GameManager(
			gameRepository: stubGameRepository,
			levelRepository: stubLevelRepository,
			levelService: mockLevelService
		)
	}

	override func tearDown() {
		mockLevelService = nil
		stubLevelRepository = nil
		stubGameRepository = nil

		sut = nil

		super.tearDown()
	}

	// MARK: - Initialization

	func test_init_shouldImplementCorrectInstance() {
		let expectedLevels = [
			Level(id: 0, cellsMatrix: [[0]]),
			Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
			Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
			Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
			Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
			Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
		]

		let expectedGame = Game(
			level: expectedLevels[0],
			taps: expectedLevels[0].id,
			levels: expectedLevels
		)

		XCTAssertEqual(sut.numberOfLevels, expectedGame.levels.count, "Expected number of levels to be \(expectedGame.levels.count), but got \(sut.numberOfLevels).")
		XCTAssertEqual(sut.currentLevelId, expectedGame.level.id, "Expected current level ID to be \(expectedGame.level.id), but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedGame.level.cellsMatrix, "Expected current level cells to be \(expectedGame.level.cellsMatrix), but got \(sut.currentLevelCells).")
		XCTAssertEqual(sut.currentTaps, expectedGame.taps, "Expected current taps to be \(expectedGame.taps), but got \(sut.currentTaps).")
		XCTAssertEqual(sut.currentLevelSize, expectedGame.level.levelSize, "Expected current level size to be \(expectedGame.level.levelSize), but got \(sut.currentLevelSize).")
		XCTAssertEqual(sut.currentlevelStatus, expectedGame.level.status, "Expected current level status to be \(expectedGame.level.status), but got \(sut.currentlevelStatus).")
	}

	// MARK: - Toggle Colors

	func test_toggleColors_withValidData_shouldCallToggleColorsAndIncrementTaps() {

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(mockLevelService.toggleColorsCalled, "Expected toggleColors to be called, but it wasn't.")
		XCTAssertEqual(sut.currentTaps, 1, "Expected taps to be 1, but got \(sut.currentTaps).")
	}

	func test_toggleColors_withInvalidCoordinates_shouldNotCalltoggleColors() {

		sut.toggleColors(atX: -1, atY: 0)

		XCTAssertFalse(mockLevelService.toggleColorsCalled, "Expected toggleColors not to be called for invalid coordinates, but it was.")
	}

	func test_toggleColors_shouldCompleteTheLevelAndSaveTheBestResult() {
		mockLevelService.checkMatrixResult = true

		let levelId = sut.currentLevelId

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(sut.currentlevelStatus, .completed(1), "Expected level to be completed with 1 tap, but got \(sut.currentlevelStatus).")

		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(sut.currentlevelStatus, .completed(3), "Expected level to be completed with 3 taps, but got \(sut.currentlevelStatus).")
		XCTAssertEqual(sut.getStarsForLevel(id: levelId), 1, "Expected best result to be 1 tap, but got \(sut.getStarsForLevel(id: levelId)).")
	}

	func test_toggleColors_shouldCallSaveGame() {

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
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

		let expectedLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(sut.currentLevelId, expectedLevel.id, "Expected to advance to level ID 1, but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedLevel.cellsMatrix, "Expected cells matrix to match for level 1, but got \(sut.currentLevelCells).")
		XCTAssertEqual(sut.currentlevelStatus, .incompleted, "Expected level to be incomplete after advancing, but got \(sut.currentlevelStatus).")
		XCTAssertEqual(sut.currentTaps, 0, "Expected taps to reset to 0, but got \(sut.currentTaps).")
	}

	func test_nextLevel_forLastLevel_shouldRemainAtLastLevel() {

		for _ in 0...6 {
			sut.nextLevel()
		}

		let expectedLevel = Level(
			id: 5,
			cellsMatrix: [
				[1, 1, 1, 1],
				[1, 0, 0, 1],
				[1, 0, 0, 1],
				[1, 1, 1, 1]
			]
		)

		XCTAssertEqual(sut.currentLevelId, expectedLevel.id, "Expected to remain at the last level (ID 5), but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedLevel.cellsMatrix, "Expected cells matrix to match for the last level, but got \(sut.currentLevelCells).")
		XCTAssertEqual(sut.currentlevelStatus, .incompleted, "Expected level to be incomplete, but got \(sut.currentlevelStatus).")
		XCTAssertEqual(sut.currentTaps, 0, "Expected taps to reset to 0, but got \(sut.currentTaps).")
	}

	func test_nextLevel_shouldCallSaveGame() {

		sut.nextLevel()

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
	}

	// MARK: - Restart Level

	func test_restartLevel_shouldResetStateToInitial() {

		sut.toggleColors(atX: 0, atY: 0)
		sut.restartLevel()

		let expectedMatrix = [[0]]

		XCTAssertEqual(sut.currentLevelCells, expectedMatrix, "Expected cells matrix to reset to initial state, but got \(sut.currentLevelCells).")
		XCTAssertEqual(sut.currentTaps, 0, "Expected taps to reset to 0, but got \(sut.currentTaps).")
		XCTAssertEqual(sut.currentlevelStatus, .incompleted, "Expected level to not be completed, but got \(sut.currentlevelStatus).")
	}

	func test_restartLevel_withMultipleActions_shouldResetToInitialState() {

		sut.nextLevel()
		sut.toggleColors(atX: 0, atY: 0)
		sut.getHint()

		sut.restartLevel()

		let expectedLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(sut.currentLevelId, expectedLevel.id, "Expected to remain at the same level (ID 1), but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedLevel.cellsMatrix, "Expected cells matrix to reset to initial state, but got \(sut.currentLevelCells).")
		XCTAssertEqual(sut.currentlevelStatus, .incompleted, "Expected level to be incomplete, but got \(sut.currentlevelStatus).")
		XCTAssertEqual(sut.currentTaps, 0, "Expected taps to reset to 0, but got \(sut.currentTaps).")
	}

	func test_restartLevel_shouldCallSaveGame() {

		sut.restartLevel()

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
	}

	// MARK: - Select Level

	func test_selectLevel_ShouldReturnSelectedLevel() {

		sut.nextLevel()
		sut.toggleColors(atX: 0, atY: 1)

		sut.selectLevel(id: 5)

		let expectedLevel = Level(
			id: 5,
			cellsMatrix: [
				[1, 1, 1, 1],
				[1, 0, 0, 1],
				[1, 0, 0, 1],
				[1, 1, 1, 1]
			]
		)

		XCTAssertEqual(sut.currentLevelId, expectedLevel.id, "Expected level ID to be \(expectedLevel.id), but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedLevel.cellsMatrix, "Expected cells matrix to match, but got \(sut.currentLevelCells).")
		XCTAssertEqual(sut.currentTaps, 0, "Expected taps to be reset to 0, but got \(sut.currentTaps).")
		XCTAssertEqual(sut.currentlevelStatus, .incompleted, "Expected level to be incomplete, but got \(sut.currentlevelStatus).")
	}

	func test_selectLevel_withInvalidId_ShouldReturnCurrentLevel() {

		let expectedLevel = Level(id: 0, cellsMatrix: [[0]])

		sut.selectLevel(id: -1)

		XCTAssertEqual(sut.currentLevelId, expectedLevel.id, "Expected level ID to remain \(expectedLevel.id), but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedLevel.cellsMatrix, "Expected cells matrix to remain the same, but got \(sut.currentLevelCells).")

		sut.selectLevel(id: Int.max)

		XCTAssertEqual(sut.currentLevelId, expectedLevel.id, "Expected level ID to remain \(expectedLevel.id), but got \(sut.currentLevelId).")
		XCTAssertEqual(sut.currentLevelCells, expectedLevel.cellsMatrix, "Expected cells matrix to remain the same, but got \(sut.currentLevelCells).")
	}

	func test_selectLevel_shouldCallSaveGame() {

		sut.selectLevel(id: 1)

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
	}

	// MARK: - Get Hint

	func test_getHint_shouldProvideHintInMatrix() {

		sut.getHint()

		XCTAssertTrue(mockLevelService.getHintCalled, "Expected getHint to be called, but it wasn't.")
	}

	// MARK: - Get Taps For Level

	func test_getTapsForLevel_withCorrectId_shouldReturnCorrectTapsForCompletedlevel() {

		var taps = sut.getTapsForLevel(id: 0)
		var expectedTaps = 0

		XCTAssertEqual(taps, 0, "Expected initial taps to be \(expectedTaps) for level 0, but got \(taps).")

		performTogglesForLevelCompletion(sut: sut, toggles: 1)

		taps = sut.getTapsForLevel(id: 0)
		expectedTaps = 1

		XCTAssertEqual(taps, 1, "Expected taps to be \(expectedTaps) for level 1, but got \(taps).")
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

		var status = sut.getStatusForLevel(id: 0)

		XCTAssertFalse(status, "Expected level 1 to be incompleted initially, but it wasn't.")

		mockLevelService.checkMatrixResult = true
		sut.toggleColors(atX: 0, atY: 0)

		status = sut.getStatusForLevel(id: 0)

		XCTAssertTrue(status, "Expected level to be completed, but it wasn't.")
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
		moveToLevel(sut, levelId: 5)
		performTogglesForLevelCompletion(sut: sut, toggles: 9)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 1

		XCTAssertEqual(sut.currentTaps, 9)
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with high number of taps, but got \(stars).")
	}

	func test_getStarsForLevel_withModerateNumberOfTaps_ShouldReturnTwoStars() {

		mockLevelService.countTargetTapsResult = 4
		moveToLevel(sut, levelId: 5)
		performTogglesForLevelCompletion(sut: sut, toggles: 5)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with moderate number of taps, but got \(stars).")
	}

	func test_getStarsForLevel_withMinimalNumberOfTaps_ShouldReturnThreeStars() {

		mockLevelService.countTargetTapsResult = 4
		moveToLevel(sut, levelId: 5)
		performTogglesForLevelCompletion(sut: sut, toggles: 4)

		let stars = sut.getStarsForLevel(id: 5)
		let expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps, but got \(stars).")
	}

	func test_getStarsForLevel_forCurrentGame_ShouldReturnActualNumberOfStars() {

		mockLevelService.countTargetTapsResult = 4

		moveToLevel(sut, levelId: 5)
		performTogglesForLevelCompletion(sut: sut, toggles: 4)

		var stars = sut.getStarsForLevel(id: 5)
		var expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 5), "Level should be completed, but it wasn't.")
		XCTAssertEqual(stars, expectedStars, "Expected \(expectedStars) stars for the level 5 with minimal number of taps, but got \(stars).")

		sut.restartLevel()
		performTogglesForLevelCompletion(sut: sut, toggles: 6)

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

private extension GameManagerTests {
	func moveToLevel(_ sut: GameManager, levelId: Int) {
		for _ in 0..<levelId {
			sut.nextLevel()
		}
	}

	func performTogglesForLevelCompletion(sut: GameManager, toggles: Int) {
		for _ in 0..<toggles - 1 {
			sut.toggleColors(atX: 0, atY: 0)
		}

		mockLevelService.checkMatrixResult = true

		sut.toggleColors(atX: 0, atY: 0)
	}
}
