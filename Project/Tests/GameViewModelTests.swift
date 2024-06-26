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

		sut.selectLevel(id: 1)

		XCTAssertTrue(mockGameManager.selectLevelCalled, "Expected selectLevel to be called, but it wasn't.")
	}

	// MARK: - Get Taps For Level

	func test_getTapsForLevel_shouldReturnCorrectTaps() {

		mockGameManager.getTapsForLevelResult = 1

		let taps = sut.getTapsForLevel(id: 0)
		let expectedTaps = 1

		XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps), but got \(taps).")
	}

	// MARK: - Get Status For Level

	func test_getStatusForLevel_shouldReturnCorrectStatus() {

		mockGameManager.getStatusForLevelResult = true

		let status = sut.getStatusForLevel(id: 0)

		XCTAssertTrue(status, "Expected status to be true, but it was false.")
	}

	// MARK: - Get Stars For Level

	func test_getStarsForLevel_shouldReturnCorrectStars() {

		mockGameManager.getStarsForLevelResult = 3

		let stars = sut.getStarsForLevel(id: 0)
		let expectedStars = 3

		XCTAssertEqual(stars, expectedStars, "Expected stars to be \(expectedStars), but got \(stars).")
	}

}
