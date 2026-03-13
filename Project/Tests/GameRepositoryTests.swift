//
//  GameRepositoryTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class GameRepositoryTests: XCTestCase {

	private var sut: GameRepository! // swiftlint:disable:this implicitly_unwrapped_optional

	override func setUp() {
		super.setUp()

		sut = GameRepository()
	}

	override func tearDown() {
		sut = nil

		super.tearDown()
	}

	// MARK: - Get New Game

	func test_getNewGame_withValidLevels_shouldReturnNewGameWithTutoriallevel() {
		let game = sut.getNewGame()
        let expectedLevel = Level(id: 0, cellsMatrix: [[0]])

        XCTAssertEqual(game.level, expectedLevel, "Expected current level to be tutorial level")
        XCTAssertEqual(game.levels.count, 1, "Expected only one level initially")
        XCTAssertEqual(game.levels[0], expectedLevel, "Expected first level to be tutorial level")
        XCTAssertTrue(game.taps.isEmpty, "Expected taps to be empty")
    }

	// MARK: - Get Saved Game

	func test_getSavedGame_fromSavedGameUrl_shouldReturnSavedGame() throws {
		let savedGame = createSavedGame()

		let savedGameData = try JSONEncoder().encode(savedGame)
		let savedGameUrl = createTemporaryFile(with: savedGameData)

		guard let game = sut.getSavedGame(from: savedGameUrl) else {
			XCTFail("Missing saved game.")
			return
		}

        XCTAssertEqual(game.level.id, 1, "Expected current level to be level 1")
        XCTAssertEqual(game.levels.count, 2, "Expected 2 levels in saved game")
        XCTAssertEqual(game.levels[0].status, .completed(1), "Expected level 0 status to be completed")
	}

	func test_getSavedGame_withInvalidUrl_shouldReturnNil() {
		let invalidUrl = URL(string: "")

		let game = sut.getSavedGame(from: invalidUrl)

		XCTAssertNil(game, "Expected game to be nil.")
	}

    func test_getSavedGame_withNilUrl_shouldReturnNil() {
        let nilUrl: URL? = nil

        let game = sut.getSavedGame(from: nilUrl)

        XCTAssertNil(game, "Expected game to be nil for nil URL")
    }

	// MARK: - Save Game

	func test_saveGame_shouldSaveGame() {
		let game = createNewGame()

		let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

		sut.saveGame(game, toUrl: tempUrl)

		XCTAssertTrue(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")

        try? FileManager.default.removeItem(at: tempUrl)
	}

    func test_saveGame_shouldSaveCorrectData() throws {
        let game = createSavedGame()

        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        sut.saveGame(game, toUrl: tempUrl)

        let savedData = try Data(contentsOf: tempUrl)
        let decodedGame = try JSONDecoder().decode(Game.self, from: savedData)

        XCTAssertEqual(decodedGame, game, "Expected saved game to match original game")

        try? FileManager.default.removeItem(at: tempUrl)
    }

	func test_saveGame_withNilUrl_shouldNotSaveGame() {
		let game = createNewGame()

		let nilUrl: URL? = nil

		sut.saveGame(game, toUrl: nilUrl)

		XCTAssertFalse(
			FileManager.default.fileExists(atPath: nilUrl?.path ?? ""),
			"Expected file not to be saved when URL is nil."
		)
	}

    func test_saveGame_shouldOverwriteExistingFile() throws {
        let game1 = createNewGame()
        let game2 = createSavedGame()

        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        sut.saveGame(game1, toUrl: tempUrl)
        sut.saveGame(game2, toUrl: tempUrl)

        let savedData = try Data(contentsOf: tempUrl)
        let decodedGame = try JSONDecoder().decode(Game.self, from: savedData)

        XCTAssertEqual(decodedGame, game2, "Expected saved game to be the second game")
        XCTAssertNotEqual(decodedGame, game1, "Expected saved game not to be the first game")

        try? FileManager.default.removeItem(at: tempUrl)
    }

	// MARK: - Delete Game

    func test_deleteGame_shouldDeleteExistingFile() {
        let game = createNewGame()

        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        sut.saveGame(game, toUrl: tempUrl)

        XCTAssertTrue(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist before deletion")

        sut.deleteGame(from: tempUrl)

        XCTAssertFalse(
            FileManager.default.fileExists(atPath: tempUrl.path),
            "Expected file not to exist after deletion"
        )
    }

    func test_deleteGame_withNilUrl_shouldHandleGracefully() {
        let nilUrl: URL? = nil

        sut.deleteGame(from: nilUrl)

        XCTAssert(true, "Expected deleteGame to handle nil URL without errors.")
    }

    func test_deleteGame_withNonExistentFile_shouldHandleGracefully() {
        let nonExistentUrl = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)

        sut.deleteGame(from: nonExistentUrl)

        XCTAssert(true, "Expected deleteGame to handle non-existent file without errors")
    }
}

private extension GameRepositoryTests {

	func createTemporaryFile(with data: Data) -> URL {
		let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		FileManager.default.createFile(atPath: url.path, contents: data)
		return url
	}

	func createSavedGame() -> Game {
        let level0 = Level(id: 0, cellsMatrix: [[0]], status: .completed(1))
        let level1 = Level(id: 1, cellsMatrix: [[0, 0], [1, 1]])

		return Game(
            level: level1,
            taps: [],
            levels: [level0, level1]
        )
	}

	func createNewGame() -> Game {
		let tutorialLevel = Level(
            id: 0,
            cellsMatrix: [[0]]
        )

		let game = Game(
            level: tutorialLevel,
            taps: [],
            levels: [tutorialLevel]
        )

		return game
	}
}
