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

	private var mockLevelService: MockLevelService!
	private var stubLevelRepository: StubLevelRepository!
	private var gameManager: GameManager!
	private var viewModel: GameViewModel!

	override func setUp() {
		super.setUp()

		mockLevelService = MockLevelService()
		stubLevelRepository = StubLevelRepository()
		gameManager = GameManager(
			levelRepository: stubLevelRepository,
			levelService: mockLevelService
		)
		viewModel = GameViewModel(gameManager: gameManager)
	}

	override func tearDown() {
		mockLevelService = nil
		stubLevelRepository = nil
		gameManager = nil
		viewModel = nil

		super.tearDown()
	}

	func test_init_shouldImplementCorrectInstance() {
		XCTAssertEqual(viewModel.levelId, 0, "Expected initial level ID to be 0.")
		XCTAssertEqual(viewModel.taps, 0, "Expected initial taps to be 0.")
		XCTAssertFalse(viewModel.isLevelCompleted, "Expected initial isLevelCompleted to be false.")
		XCTAssertEqual(viewModel.isTutorialLevel, true, "Expected initial isTutorialLevel to be true.")
		XCTAssertEqual(viewModel.cells, [[0]], "Expected initial cells matrix to match the first level's cells matrix.")
	}

	func test_cellTapped_shouldCallToggleColorsAndCompleteTheLevel() {

		mockLevelService.checkMatrixResult = true

		viewModel.cellTapped(atX: 0, atY: 0)

		XCTAssertTrue(mockLevelService.toggleColorsCalled, "Expected toggleColors to be called.")
		XCTAssertTrue(viewModel.isLevelCompleted, "Expected isLevelCompleted to be true after toggling colors.")
	}

	func test_cellTapped_shouldCallToggleColorsAndNotCompleteTheLevel() {

		viewModel.cellTapped(atX: 0, atY: 0)

		XCTAssertTrue(mockLevelService.toggleColorsCalled, "Expected toggleColors to be called.")
		XCTAssertFalse(viewModel.isLevelCompleted, "Expected isLevelCompleted to be false after toggling colors.")
	}

	func test_nextLevel_shouldCallNextLevel() {

		XCTAssertEqual(viewModel.levelId, 0)

		viewModel.nextLevel()

		XCTAssertEqual(viewModel.levelId, 1)
	}

}
