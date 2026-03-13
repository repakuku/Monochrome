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
	private var stubGameRepository: StubGameRepository! // swiftlint:disable:this implicitly_unwrapped_optional
    private var mockLevelGenerator: MockLevelGenerator! // swiftlint:disable:this implicitly_unwrapped_optional

	private var sut: GameManager! // swiftlint:disable:this implicitly_unwrapped_optional

	override func setUp() {
		super.setUp()

		mockLevelService = MockLevelService()
		stubGameRepository = StubGameRepository()
        mockLevelGenerator = MockLevelGenerator()

        sut = GameManager(
            gameRepository: stubGameRepository,
            levelService: mockLevelService,
            levelGenerator: mockLevelGenerator
        )
    }

	override func tearDown() {
		mockLevelService = nil
		stubGameRepository = nil
        mockLevelGenerator = nil

		sut = nil

		super.tearDown()
	}

	// MARK: - Initialization

	func test_init_withoutSavedGame_shouldImplementCorrectInstanceWithNewGame() {

		let expectedGame = createNewGame()

		XCTAssertEqual(sut.game, expectedGame, "Expected game to be \(expectedGame), but got \(sut.game).")
	}

	func test_init_withSavedGame_shouldImplementCorrectInstanceWithSavedGame() {
        let level0 = Level(id: 0, cellsMatrix: [[0]], status: .completed(1))
        let level1 = Level(id: 1, cellsMatrix: [[0, 0], [1, 0]])

        let savedGame = Game(
            level: level1,
            taps: [],
            levels: [level0, level1]
        )

        stubGameRepository.savedGame = savedGame

        sut = GameManager(
            gameRepository: stubGameRepository,
            levelService: mockLevelService,
            levelGenerator: mockLevelGenerator
        )

        XCTAssertEqual(sut.game, savedGame, "Expected game to be \(savedGame), but got \(sut.game).")
	}

	// MARK: - Toggle Colors

	func test_toggleColors_withValidData_shouldCallToggleColorsAndIncrementTaps() {
		sut.toggleColors(atX: 0, atY: 0)

		XCTAssertTrue(mockLevelService.toggleColorsCalled, "Expected toggleColors to be called, but it wasn't.")
		XCTAssertEqual(sut.game.taps.count, 1, "Expected taps to be 1, but got \(sut.game.taps.count).")
	}

	func test_toggleColors_withInvalidCoordinates_shouldNotCallToggleColors() {
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
        XCTAssertEqual(
            sut.game.levels[levelId].status,
            .completed(1),
            "Expected level in levels array to be completed with 1 tap"
        )

        sut.restartLevel()

        for _ in 0..<2 {
            sut.toggleColors(atX: 0, atY: 0)
        }

        mockLevelService.checkMatrixResult = true
        sut.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(
			sut.game.level.status,
			.completed(3),
			"Expected level to be completed with 3 taps, but got \(sut.game.level.status)."
		)
        XCTAssertEqual(
            sut.game.levels[levelId].status,
            .completed(1),
            "Expected best result in levels array to remain 1 tap"
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

    func test_nextLevel_shouldGenerateAndAdvanceToNextLevel() {
        sut.nextLevel(size: 2)

        XCTAssertTrue(mockLevelGenerator.generateRandomLevelCalled, "Expected generator to be called")
        XCTAssertEqual(mockLevelGenerator.lastGeneratedId, 1, "Expected new level id to be 1")
        XCTAssertEqual(mockLevelGenerator.lastGeneratedSize, 2, "Expected size to be 2")
        XCTAssertEqual(sut.game.level.id, 1, "Expected to advance to level 1")
        XCTAssertEqual(sut.game.levels.count, 2, "Expected 2 levels in total")
        XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset")
        XCTAssertEqual(sut.game.level.status, .incompleted, "Expected level status to be incompleted")
    }

    func test_nextLevel_whenReplayingOldLevel_shouldMoveToLastUnsolvedLevel() {
        sut.nextLevel(size: 2)  // level 1
        sut.nextLevel(size: 2)  // level 2

        sut.selectLevel(id: 0)  // Возвращаемся на level 0

        mockLevelGenerator.generateRandomLevelCalled = false

        sut.nextLevel(size: 2)

        XCTAssertFalse(mockLevelGenerator.generateRandomLevelCalled, "Expected generator NOT to be called")
        XCTAssertEqual(sut.game.level.id, 2, "Expected to move to last unsolved level 2")
        XCTAssertEqual(sut.game.levels.count, 3, "Expected levels count to remain 3")
        XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset")
    }

    func test_nextLevel_shouldCallSaveGame() {
        sut.nextLevel(size: 2)

        XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after nextLevel.")
    }

    func test_nextLevel_afterCompletingLevel_shouldMoveToNextLevel() {
        mockLevelService.checkMatrixResult = true
        sut.toggleColors(atX: 0, atY: 0)

        XCTAssertEqual(sut.game.level.status, .completed(1), "Expected level status to be .completed(1).")

        sut.nextLevel(size: 2)

        XCTAssertEqual(sut.game.level.id, 1, "Expected to advance to level 1")
        XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset to 0")
        XCTAssertEqual(sut.game.level.status, .incompleted, "Expected new level status to be incompleted")
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

    func test_restartLevel_immediatelyAfterLevelCompletion_shouldResetStateToInitial() {
        sut.nextLevel(size: 2)

        performTogglesForLevelCompletion(sut: sut, toggles: 1)

        XCTAssertEqual(sut.game.level.status, .completed(1))

        let originalMatrix = sut.game.levels[1].cellsMatrix

        sut.restartLevel()

        XCTAssertEqual(
            sut.game.level.cellsMatrix,
            originalMatrix,
            "Expected cells matrix to reset to initial state"
        )
        XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset to 0")
        XCTAssertEqual(
            sut.game.level.status,
            .incompleted,
            "Expected level to not be completed"
        )
    }

    func test_restartLevel_withMultipleActions_shouldResetToInitialState() {
        sut.nextLevel(size: 2)
        sut.toggleColors(atX: 0, atY: 0)
        sut.getHint()

        let originalMatrix = sut.game.levels[1].cellsMatrix

        sut.restartLevel()

        XCTAssertEqual(sut.game.level.id, 1, "Expected to remain at level 1")
        XCTAssertEqual(sut.game.level.cellsMatrix, originalMatrix, "Expected matrix to reset")
        XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to reset to 0")
    }

	func test_restartLevel_shouldCallSaveGame() {
		sut.restartLevel()

		XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after toggle.")
	}

	// MARK: - Select Level

    func test_selectLevel_shouldReturnSelectedLevel() {
        sut.nextLevel(size: 2)
        sut.nextLevel(size: 2)
        sut.nextLevel(size: 2)

        sut.toggleColors(atX: 0, atY: 1)

        sut.selectLevel(id: 2)

        XCTAssertEqual(sut.game.level.id, 2, "Expected level id to be 2")
        XCTAssertEqual(sut.game.taps.count, 0, "Expected taps to be 0")
        XCTAssertEqual(sut.game.level.status, .incompleted, "Expected status to be incompleted")
    }

    func test_selectLevel_withInvalidId_shouldReturnCurrentLevel() {
        let expectedLevel = Level(id: 0, cellsMatrix: [[0]])

        sut.selectLevel(id: -1)

        XCTAssertEqual(
            sut.game.level,
            expectedLevel,
            "Expected level to be \(expectedLevel), but got \(sut.game.level)."
        )

        sut.selectLevel(id: Int.max)

        XCTAssertEqual(
            sut.game.level,
            expectedLevel,
            "Expected level to be \(expectedLevel), but got \(sut.game.level)."
        )
    }

    func test_selectLevel_shouldCallSaveGame() {
        sut.nextLevel(size: 2)
        stubGameRepository.saveGameCalled = false

        sut.selectLevel(id: 1)

        XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGameCalled to be true after select.")
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

    func test_getTapsForLevel_withIncorrectId_shouldReturnZero() {
        var taps = sut.getTapsForLevel(id: -1)
        let expectedTaps = 0

        XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID, but got \(taps).")

        taps = sut.getTapsForLevel(id: Int.max)

        XCTAssertEqual(taps, expectedTaps, "Expected taps to be \(expectedTaps) for invalid level ID, but got \(taps).")
    }

	// MARK: - Get Status For Level

    func test_getStatusForLevel_withValidId_shouldReturnCorrectStatus() {
        var status = sut.getStatusForLevel(id: 0)

        XCTAssertFalse(status, "Expected level 0 to be incompleted initially, but it wasn't.")

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

    func test_getStarsForLevel_forNonExistentLevel_shouldReturnZeroStars() {
        mockLevelService.countTargetTapsResult = 4

        let stars = sut.getStarsForLevel(id: 5)
        let expectedStars = 0

        XCTAssertEqual(
            stars,
            expectedStars,
            "Expected \(expectedStars) stars for non-existent level, but got \(stars)."
        )
    }

    func test_getStarsForLevel_withHighNumberOfTaps_shouldReturnOneStar() {
        mockLevelService.countTargetTapsResult = 4
        moveToLevel(sut, levelId: 3, size: 2)
        performTogglesForLevelCompletion(sut: sut, toggles: 9)

        let stars = sut.getStarsForLevel(id: 3)
        let expectedStars = 1

        XCTAssertEqual(
            stars,
            expectedStars,
            "Expected \(expectedStars) stars for level 3 with high number of taps, but got \(stars)."
        )
    }

    func test_getStarsForLevel_withModerateNumberOfTaps_shouldReturnTwoStars() {
        mockLevelService.countTargetTapsResult = 4
        moveToLevel(sut, levelId: 3, size: 2)
        performTogglesForLevelCompletion(sut: sut, toggles: 5)

        let stars = sut.getStarsForLevel(id: 3)
        let expectedStars = 2

        XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
        XCTAssertEqual(
            stars,
            expectedStars,
            "Expected \(expectedStars) stars for level 3 with moderate number of taps, but got \(stars)."
        )
    }

    func test_getStarsForLevel_withMinimalNumberOfTaps_shouldReturnThreeStars() {
        mockLevelService.countTargetTapsResult = 4
        moveToLevel(sut, levelId: 3, size: 2)
        performTogglesForLevelCompletion(sut: sut, toggles: 4)

        let stars = sut.getStarsForLevel(id: 3)
        let expectedStars = 3

        XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
        XCTAssertEqual(
            stars,
            expectedStars,
            "Expected \(expectedStars) stars for level 3 with minimal number of taps, but got \(stars)."
        )
    }

    func test_getStarsForLevel_forCurrentGame_shouldReturnActualNumberOfStars() {
        mockLevelService.countTargetTapsResult = 4

        moveToLevel(sut, levelId: 3, size: 2)
        performTogglesForLevelCompletion(sut: sut, toggles: 4)

        var stars = sut.getStarsForLevel(id: 3)
        var expectedStars = 3

        XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
        XCTAssertEqual(
            stars,
            expectedStars,
            "Expected \(expectedStars) stars for level 3 with minimal number of taps, but got \(stars)."
        )

        sut.restartLevel()
        performTogglesForLevelCompletion(sut: sut, toggles: 6)

        stars = sut.getStarsForLevel(id: 3, forCurrentGame: true)
        expectedStars = 2

        XCTAssertTrue(sut.getStatusForLevel(id: 3), "Level should be completed, but it wasn't.")
        XCTAssertEqual(
            stars,
            expectedStars,
            "Expected \(expectedStars) stars for level 3 after replay, but got \(stars)."
        )
    }

    func test_getStarsForLevel_withInvalidId_shouldReturnZeroStars() {
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
        moveToLevel(sut, levelId: 5, size: 2)

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

    func test_undoLastTap_shouldCallSaveGame() {
        moveToLevel(sut, levelId: 5, size: 2)

        sut.toggleColors(atX: 0, atY: 0)
        stubGameRepository.saveGameCalled = false

        sut.undoLastTap()

        XCTAssertTrue(stubGameRepository.saveGameCalled, "Expected saveGame to be called, but it wasn't.")
    }

	// MARK: - Reset Progress

    func test_resetProgress_shouldCallDeleteSavedGameAndResetProgress() {
        sut.resetProgress()

        XCTAssertTrue(stubGameRepository.deleteSavedGameCalled, "Expected deleteSavedGame to be called, but it wasn't.")

        let expectedGame = createNewGame()

        XCTAssertEqual(sut.game, expectedGame, "Expected game to be \(expectedGame), but got \(sut.game).")
    }
}

private extension GameManagerTests {
    func moveToLevel(_ sut: GameManager, levelId: Int, size: Int = 2) {
		for _ in 0..<levelId {
			sut.nextLevel(size: size)
		}
	}

	func performTogglesForLevelCompletion(sut: GameManager, toggles: Int) {
		for _ in 0..<toggles - 1 {
			sut.toggleColors(atX: 0, atY: 0)
		}

		mockLevelService.checkMatrixResult = true

		sut.toggleColors(atX: 0, atY: 0)
	}

	private func createNewGame() -> Game {
        let tutorialLevel = Level(id: 0, cellsMatrix: [[0]])

		return Game(
            level: tutorialLevel,
            taps: [],
            levels: [tutorialLevel]
        )
	}
}
