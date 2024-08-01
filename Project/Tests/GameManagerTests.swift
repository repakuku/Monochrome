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

	private var mockLevelService: MockLevelService! // swiftlint:disable:this implicitly_unwrapped_optional
	private var stubLevelRepository: StubLevelRepository! // swiftlint:disable:this implicitly_unwrapped_optional
	private var stubGameRepository: StubGameRepository! // swiftlint:disable:this implicitly_unwrapped_optional

	private var sut: GameManager! // swiftlint:disable:this implicitly_unwrapped_optional

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

	func test_init_withoutSavedGame_shouldImplementCorrectInstanceWithNewGame() {

		let expectedGame = createGame()

		XCTAssertEqual(sut.game, expectedGame, "Expected game to be \(expectedGame), but got \(sut.game).")
	}

	func test_init_withSavedGame_shouldImplementCorrectInstanceWithSavedGame() {

		let savedLevel = Level(
			id: 0,
			cellsMatrix: [[1]],
			status: .completed(1)
		)

		let savedGame = Game(
			currentLevelId: savedLevel.id,
			taps: [Tap(row: 0, col: 0)],
			levels: [savedLevel],
			levelsHash: "savedHash"
		)

		stubGameRepository.savedGame = savedGame

		sut = GameManager(
			gameRepository: stubGameRepository,
			levelRepository: stubLevelRepository,
			levelService: mockLevelService
		)

		XCTAssertEqual(sut.game, savedGame, "Expected game to be \(savedGame), but got \(sut.game).")
	}

	// MARK: - Update Game

	func test_updateGame_withSameFetchedLevels_shouldNotUpdateGame() async {

		var savedGame = createGame()
		let savedLevelsHash = HashService.calculateHash(of: savedGame.levels)
		savedGame.levelsHash = savedLevelsHash

		let fetchedLevels = savedGame.levels

		stubLevelRepository.fetchedLevels = fetchedLevels

		await sut.updateGame()

		XCTAssertEqual(sut.game, savedGame, "Expected game to be \(savedGame), but got \(sut.game).")
	}

	func test_updateGame_withChangedFetchedLevels_shouldUpdateGameWithNewLevels() async {

		var savedGame = createGame()
		let savedLevelsHash = HashService.calculateHash(of: savedGame.levels)
		savedGame.levelsHash = savedLevelsHash

		let fetchedLevels = [
			Level(
				id: 0,
				cellsMatrix: [[1]],
				status: .completed(1)
			)
		]

		let fetchedLevelsHash = HashService.calculateHash(of: fetchedLevels)

		stubGameRepository.savedGame = savedGame
		stubLevelRepository.fetchedLevels = fetchedLevels

		let expectedGame = Game(
			currentLevelId: 0,
			levels: fetchedLevels,
			levelsHash: fetchedLevelsHash
		)

		await sut.updateGame()

		XCTAssertEqual(sut.game, expectedGame, "Expected game to be \(expectedGame), but got \(sut.game).")
	}

	// MARK: - Toggle Colors

	func test_toggleColors_withValidData_shouldCallToggleColorsAndIncrementTaps() {

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(mockLevelService.toggleColorsCalled, "Expected toggleColors to be called, but it wasn't.")
		XCTAssertEqual(sut.game.taps.count, 1, "Expected taps to be 1, but got \(sut.game.taps.count).")
	}

	func test_toggleColors_withInvalidCoordinates_shouldNotCalltoggleColors() {

		sut.toggleColors(atX: -1, atY: 0)

		XCTAssertFalse(
			mockLevelService.toggleColorsCalled,
			"Expected toggleColors not to be called for invalid coordinates, but it was."
		)
	}

	func test_toggleColors_shouldCompleteTheLevelAndSaveTheBestResult() {
		mockLevelService.checkMatrixResult = true

		let levelId = sut.game.level.id

		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(
			sut.game.level.status,
			.completed(1),
			"Expected level to be completed with 1 tap, but got \(sut.game.level.status)."
		)

		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(
			sut.game.level.status,
			.completed(3),
			"Expected level to be completed with 3 taps, but got \(sut.game.level.status)."
		)
		XCTAssertEqual(
			sut.getStarsForLevel(id: levelId),
			1,
			"Expected best result to be 1 tap, but got \(sut.getStarsForLevel(id: levelId))."
		)
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

		XCTAssertEqual(
			sut.game.level,
			expectedLevel,
			"Expected to advance to level \(expectedLevel), but got \(sut.game.level)."
		)
		XCTAssertEqual(
			sut.game.taps.count,
			0,
			"Expected taps to reset to 0, but got \(sut.game.taps.count)."
		)
		XCTAssertEqual(
			sut.game.level.status,
			.incompleted,
			"Expected levels status to reset to incompleted, but got \(sut.game.level.status)."
		)
	}

	func test_nextLevel_forLastLevel_shouldRemainAtLastLevel() {

		for _ in 0...6 {
			sut.nextLevel()
		}

		let expectedLevel = Level(id: 3, cellsMatrix: [[1, 0], [1, 1]])

		XCTAssertEqual(
			sut.game.level,
			expectedLevel,
			"Expected to remain at the last level \(expectedLevel), but got \(sut.game.level)."
		)
		XCTAssertEqual(
			sut.game.taps.count,
			0,
			"Expected taps to reset to 0, but got \(sut.game.taps.count)."
		)
	}

	func test_nextLevel_shouldCallSaveGame() {

		sut.nextLevel()

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
	}

	func test_nextLevel_toCompletedLevel_shouldReturnUncomplitedLevel() {

		sut.selectLevel(id: 1)

		performTogglesForLevelCompletion(sut: sut, toggles: 1)

		XCTAssertEqual(sut.game.level.status, .completed(1), "Expected level status to be .completed(1).")

		sut.selectLevel(id: 0)

		sut.nextLevel()

		let expectedLevel = Level(
			id: 1,
			cellsMatrix: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(
			sut.game.level,
			expectedLevel,
			"Expected to advance to level \(expectedLevel), but got \(sut.game.level)."
		)
		XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset to 0, but got \(sut.game.taps.count).")
	}

	// MARK: - Restart Level

	func test_restartLevel_shouldResetStateToInitial() {

		sut.toggleColors(atX: 0, atY: 0)
		sut.restartLevel()

		let expectedMatrix = [[0]]

		XCTAssertEqual(
			sut.game.level.cellsMatrix,
			expectedMatrix,
			"Expected cells matrix to reset to initial state, but got \(sut.game.level.cellsMatrix)."
		)
		XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset to 0, but got \(sut.game.taps.count).")
		XCTAssertEqual(
			sut.game.level.status,
			.incompleted,
			"Expected level to not be completed, but got \(sut.game.level.status)."
		)
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

		XCTAssertEqual(sut.game.level, expectedLevel, "Expected to remain at the same level, but got \(sut.game.level).")
		XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset to 0, but got \(sut.game.taps.count).")
	}

	func test_restartLevel_shouldCallSaveGame() {

		sut.restartLevel()

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
	}

	// MARK: - Select Level

	func test_selectLevel_ShouldReturnSelectedLevel() {

		sut.nextLevel()
		sut.toggleColors(atX: 0, atY: 1)

		sut.selectLevel(id: 3)

		let expectedLevel = Level(id: 3, cellsMatrix: [[1, 0], [1, 1]])

		XCTAssertEqual(sut.game.level, expectedLevel, "Expected level to be \(expectedLevel), but got \(sut.game.level).")
		XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to be 0, but got \(sut.game.taps.count).")
	}

	func test_selectLevel_withInvalidId_ShouldReturnCurrentLevel() {

		let expectedLevel = Level(id: 0, cellsMatrix: [[0]])

		sut.selectLevel(id: -1)

		XCTAssertEqual(sut.game.level, expectedLevel, "Expected level to be \(expectedLevel), but got \(sut.game.level).")

		sut.selectLevel(id: Int.max)

		XCTAssertEqual(sut.game.level, expectedLevel, "Expected level to be \(expectedLevel), but got \(sut.game.level).")
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
		moveToLevel(sut, levelId: 3)
		performTogglesForLevelCompletion(sut: sut, toggles: 9)

		let stars = sut.getStarsForLevel(id: 3)
		let expectedStars = 1

		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for the level 5 with high number of taps, but got \(stars)."
		)
	}

	func test_getStarsForLevel_withModerateNumberOfTaps_ShouldReturnTwoStars() {

		mockLevelService.countTargetTapsResult = 4
		moveToLevel(sut, levelId: 3)
		performTogglesForLevelCompletion(sut: sut, toggles: 5)

		let stars = sut.getStarsForLevel(id: 3)
		let expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for the level 5 with moderate number of taps, but got \(stars)."
		)
	}

	func test_getStarsForLevel_withMinimalNumberOfTaps_ShouldReturnThreeStars() {

		mockLevelService.countTargetTapsResult = 4
		moveToLevel(sut, levelId: 3)
		performTogglesForLevelCompletion(sut: sut, toggles: 4)

		let stars = sut.getStarsForLevel(id: 3)
		let expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for the level 5 with minimal number of taps, but got \(stars)."
		)
	}

	func test_getStarsForLevel_forCurrentGame_ShouldReturnActualNumberOfStars() {

		mockLevelService.countTargetTapsResult = 4

		moveToLevel(sut, levelId: 3)
		performTogglesForLevelCompletion(sut: sut, toggles: 4)

		var stars = sut.getStarsForLevel(id: 3)
		var expectedStars = 3

		XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for the level 5 with minimal number of taps, but got \(stars)."
		)

		sut.restartLevel()
		performTogglesForLevelCompletion(sut: sut, toggles: 6)

		stars = sut.getStarsForLevel(id: 3, forCurrentGame: true)
		expectedStars = 2

		XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for the level 5 after replay, but got \(stars)."
		)
	}

	func test_getStarsForLevel_withInvalidId_ShouldReturnZeroStars() {

		var stars = sut.getStarsForLevel(id: -1)
		let expectedStars = 0

		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for an invalid level ID, but got \(stars)."
		)

		stars = sut.getStarsForLevel(id: Int.max)

		XCTAssertEqual(
			stars,
			expectedStars,
			"Expected \(expectedStars) stars for an invalid level ID, but got \(stars)."
		)
	}

	// MARK: Undo Last Tap

	func test_undoLastTap_shouldRemoveLastTapAndCallToggleColors() {

		moveToLevel(sut, levelId: 5)

		var expectedTaps = [
			Tap(row: 0, col: 0),
			Tap(row: 1, col: 1)
		]

		sut.toggleColors(atX: 0, atY: 0)
		sut.toggleColors(atX: 1, atY: 1)

		XCTAssertEqual(sut.game.taps, expectedTaps, "Expected taps to be recorded.")

		expectedTaps = [
			Tap(row: 0, col: 0)
		]

		sut.undoLastTap()

		XCTAssertEqual(sut.game.taps, expectedTaps, "Expected last tap to be removed.")
		XCTAssertEqual(
			mockLevelService.toggleColorsCalledCount,
			3,
			"Expected toggleColors to be called three times (two taps and one undo)."
		)

		sut.undoLastTap()

		XCTAssertTrue(sut.game.taps.isEmpty, "Expected all taps to be removed.")
		XCTAssertEqual(
			mockLevelService.toggleColorsCalledCount,
			4,
			"Expected toggleColors to be called four times (two taps and two undos)."
		)

		sut.undoLastTap()

		XCTAssertTrue(sut.game.taps.isEmpty, "Expected no change in taps when undo is called with no taps.")
		XCTAssertEqual(
			mockLevelService.toggleColorsCalledCount,
			4,
			"Expected toggleColors to not be called when undo is called with no taps."
		)
	}

	// MARK: - Reset Progress

	func test_resetProgress_shouldCallDeleteSavedGameAndResetProgress() {

		sut.resetProgress()

		XCTAssertTrue(stubGameRepository.deleteSavedGameCalled, "Expected deleteSavedGame to be called, but it wasn't.")

		let expectedGame = createGame()

		XCTAssertEqual(sut.game, expectedGame, "Expected game to be \(expectedGame), but got \(sut.game).")
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

	private func createGame() -> Game {
		let levels = [
			Level(id: 0, cellsMatrix: [[0]]),
			Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
			Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
			Level(id: 3, cellsMatrix: [[1, 0], [1, 1]])
		]

		return Game(
			currentLevelId: 0,
			levels: levels,
			levelsHash: "hash"
		)
	}
}
