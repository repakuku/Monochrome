//
//  GameViewModelTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/25/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class GameViewModelTests: XCTestCase {

	private var mockGameManager: MockGameManager!
	private var sut: GameViewModel!

	override func setUp() {
		super.setUp()
		mockGameManager = MockGameManager()
		sut = GameViewModel(gameManager: mockGameManager)
	}

	override func tearDown() {
		mockGameManager = nil
		sut = nil
		super.tearDown()
	}

	// MARK: - Initialization

	func test_init_shouldImplementCorrectInstance() {
		XCTAssertEqual(sut.levelId, 0, "Expected initial level ID to be 0, but got \(sut.levelId).")
		XCTAssertEqual(sut.taps, 0, "Expected initial taps to be 0, but got \(sut.taps).")
		XCTAssertFalse(sut.isLevelCompleted, "Expected initial isLevelCompleted to be false, but it was true.")
		XCTAssertEqual(sut.isTutorialLevel, true, "Expected initial isTutorialLevel to be true, but got \(sut.isTutorialLevel).")
		XCTAssertEqual(sut.cells, [[0]], "Expected initial cells matrix to match the first level's cells matrix, but got \(sut.cells).")
		XCTAssertEqual(sut.numberOfLevels, 1, "Expected number of levels to be 1, but got \(sut.numberOfLevels).")
	}

	// MARK: - Cell Tapped

	func test_cellTapped_shouldCallToggleColors() {

		sut.cellTapped(atX: 0, atY: 0)

		XCTAssertTrue(mockGameManager.toggleColorsCalled, "Expected toggleColors to be called, but it wasn't.")
	}

	func test_cellTapped_forCompletedLevel_isLeveleCompletedShouldBecomeTrue() {

		mockGameManager.game.level.status = .completed(1)

		sut.cellTapped(atX: 0, atY: 0)

		XCTAssertTrue(sut.isLevelCompleted, "Expected isLevelCompleted to be true after completing the level, but it was false.")
	}

	func test_cellTapped_forIncompleteLevel_isLevelCompletedShouldRemainFalse() {
		mockGameManager.game.level.status = .incompleted

		sut.cellTapped(atX: 0, atY: 0)

		XCTAssertFalse(sut.isLevelCompleted, "Expected isLevelCompleted to be false for an incomplete level, but it was true.")
	}

	func test_cellTapped_withInvalidCoordinates_shouldNotCalltoggleColors() {

		sut.cellTapped(atX: -1, atY: 0)

		XCTAssertFalse(mockGameManager.toggleColorsCalled, "Expected toggleColors not to be called for invalid coordinates, but it was.")
	}

	// MARK: - Next Level

	func test_nextLevel_shouldCallNextLevel() {

		sut.nextLevel()

		XCTAssertTrue(mockGameManager.nextLevelCalled, "Expected nextLevel to be called, but it wasn't.")
		XCTAssertFalse(sut.isLevelCompleted, "Expected isLevelCompleted to be false after calling nextLevel, but it was true.")
	}

	// MARK: - Restart Level

	func test_restartlevel_shouldCallRestartLevel() {

		sut.restartLevel()

		XCTAssertTrue(mockGameManager.restartLevelCalled, "Expected restartLevel to be called, but it wasn't.")
		XCTAssertFalse(sut.isLevelCompleted, "Expected isLevelCompleted to be false after calling restartLevel, but it was true.")
	}

	// MARK: - Get Hint

	func test_getHint_shouldCallGetHint() {

		sut.getHint()

		XCTAssertTrue(mockGameManager.getHintCalled, "Expected getHint to be called, but it wasn't.")
	}

	// MARK: - Select Level

	func test_selectLevel_shouldCallSelectLevel() {

		sut.selectLevel(id: 0)

		XCTAssertTrue(mockGameManager.selectLevelCalled, "Expected selectLevel to be called, but it wasn't.")
	}

	func test_selectLevel_withInvalidId_shouldNotCallSelectLevel() {
		sut.selectLevel(id: -1)

		XCTAssertFalse(mockGameManager.selectLevelCalled, "Expected selectLevel to not be called for invalid ID, but it was.")

		sut.selectLevel(id: Int.max)

		XCTAssertFalse(mockGameManager.selectLevelCalled, "Expected selectLevel to not be called for invalid ID, but it was.")
	}

	// MARK: - Get Taps For Level

	func test_getTapsForLevel_shouldReturnCorrectTaps() {

		mockGameManager.getTapsForLevelResult = 1

		let taps = sut.getTapsForLevel(id: 0)
		let expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps), but got \(taps).")
	}

	func test_getTapsForLevel_withInvalidId_shouldReturnZero() {

		var taps = sut.getTapsForLevel(id: -1)

		XCTAssertEqual(taps, 0, "Expected taps to be 0 for invalid ID, but got \(taps).")

		taps = sut.getTapsForLevel(id: Int.max)

		XCTAssertEqual(taps, 0, "Expected taps to be 0 for invalid ID, but got \(taps).")
	}

	// MARK: - Get Status For Level

	func test_getStatusForLevel_shouldReturnCorrectStatus() {

		mockGameManager.getStatusForLevelResult = true

		let status = sut.getStatusForLevel(id: 0)

		XCTAssertTrue(status, "Expected status to be true, but it was false.")
	}

	func test_getStatusForLevel_withInvalidId_shouldReturnFalse() {

		var status = sut.getStatusForLevel(id: -1)

		XCTAssertFalse(status, "Expected status to be false for invalid ID, but it was true.")

		status = sut.getStatusForLevel(id: Int.max)

		XCTAssertFalse(status, "Expected status to be false for invalid ID, but it was true.")
	}

	// MARK: - Get Stars For Level

	func test_getStarsForLevel_shouldReturnCorrectStars() {

		mockGameManager.getStarsForLevelResult = 3

		let stars = sut.getStarsForLevel(id: 0)
		let expectedStars = 3

		XCTAssertEqual(stars, expectedStars, "Expected stars to be \(expectedStars), but got \(stars).")
	}

	func test_getStarsForLevel_withInvalidId_shouldReturnZeroStars() {

		var stars = sut.getStarsForLevel(id: -1)

		XCTAssertEqual(stars, 0, "Expected stars to be 0 for invalid ID, but got \(stars).")

		stars = sut.getStarsForLevel(id: Int.max)

		XCTAssertEqual(stars, 0, "Expected stars to be 0 for invalid ID, but got \(stars).")
	}

	// MARK: - Erase Button Tapped

	func test_eraserButtonTapped_shouldCallResetProgressAndupdateGameState() {
		
		sut.eraserButtonTapped()

		XCTAssertTrue(mockGameManager.resetProgressCalled, "Expected resetProgress to be called, but it wasn't.")
		XCTAssertEqual(sut.levelId, 0, "Expected initial level ID to be 0, but got \(sut.levelId).")
		XCTAssertEqual(sut.taps, 0, "Expected initial taps to be 0, but got \(sut.taps).")
		XCTAssertFalse(sut.isLevelCompleted, "Expected initial isLevelCompleted to be false, but it was true.")
		XCTAssertTrue(sut.isTutorialLevel, "Expected initial isTutorialLevel to be true, but got \(sut.isTutorialLevel).")
		XCTAssertEqual(sut.cells, [[0]], "Expected initial cells matrix to match the first level's cells matrix, but got \(sut.cells).")
		XCTAssertEqual(sut.numberOfLevels, 1, "Expected number of levels to be 1, but got \(sut.numberOfLevels).")
	}

}
