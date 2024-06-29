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

	private var stubLevelRepository: StubLevelRepository!
	private var sut: GameRepository!

	override func setUp() {
		super.setUp()

		stubLevelRepository = StubLevelRepository()
		sut = GameRepository(levelRepository: stubLevelRepository)
	}

	override func tearDown() {
		stubLevelRepository = nil
		sut = nil

		super.tearDown()
	}

	// MARK: - Get Saved Game

	func test_getSavedGame_forTheFirstRun_shouldReturnNewGame() {

		let emptyData = Data()
		let url = createTemporaryFile(with: emptyData)
		let game = sut.getGame(from: url)

		assertNewGame(game: game)
	}

	func test_getSavedGame_withInvalidUrl_shouldReturnNewGame() {
		let invalidUrl = URL(string: "")
		let game = sut.getGame(from: invalidUrl)

		assertNewGame(game: game)
	}

	func test_getSavedGame_withInvalidJson_shouldReturnNewGame() {
		let invalidJson = "invalid json".data(using: .utf8)!
		let invalidJsonUrl = createTemporaryFile(with: invalidJson)
		let game = sut.getGame(from: invalidJsonUrl)

		assertNewGame(game: game)
	}

	func test_getSavedGame_shouldReturnSavedGame() {
		let savedGame = Game(
			level: Level(id: 1, cellsMatrix: [[0, 1], [1, 0]]),
			taps: [],
			levels: [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		)
		let savedGameData = try! JSONEncoder().encode(savedGame)
		let savedgameUrl = createTemporaryFile(with: savedGameData)

		let game = sut.getGame(from: savedgameUrl)

		XCTAssertEqual(game, savedGame, "Expected saved game to be \(savedGame), but got \(game).")
	}

	// MARK: - Save Game

	func test_saveGame_shouldSaveGame() {
		let game = Game(
			level: Level(id: 1, cellsMatrix: [[0, 1], [1, 0]]),
			taps: [],
			levels: [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		)

		let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

		sut.saveGame(game, to: tempUrl)

		XCTAssertTrue(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")
	}

	func test_saveGame_withNilUrl_shouldNotSaveGame() {
		let game = Game(
			level: Level(id: 1, cellsMatrix: [[0, 1], [1, 0]]),
			taps: [],
			levels: [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		)

		let nilUrl: URL? = nil

		sut.saveGame(game, to: nilUrl)

		XCTAssertFalse(FileManager.default.fileExists(atPath: nilUrl?.path ?? ""), "Expected file not to be saved when URL is nil.")
	}

	// MARK: - Delete Saved Game

	func test_deleteSavedGame_shouldDeleteGame() {
		let game = Game(
			level: Level(id: 1, cellsMatrix: [[0, 1], [1, 0]]),
			taps: [],
			levels: [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		)

		let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

		sut.saveGame(game, to: tempUrl)

		XCTAssertTrue(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")

		sut.deleteSavedGame(from: tempUrl)

		XCTAssertFalse(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")
	}

	func test_deleteSavedGame_withNilUrl_shouldDeleteGame() {
		let nilUrl: URL? = nil

		sut.deleteSavedGame(from: nilUrl)

		XCTAssert(true, "Expected deleteSavedGame to handle nil URL without errors.")
	}
}

private extension GameRepositoryTests {
	func assertNewGame(
		game: Game,
		file: StaticString = #file,
		line: UInt = #line
	) {
		let expectedGame = Game(
			level: Level(id: 0, cellsMatrix: [[0]]),
			taps: [],
			levels: [
				Level(id: 0, cellsMatrix: [[0]]),
				Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
				Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
				Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
				Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
				Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
			]
		)

		XCTAssertEqual(game.level, expectedGame.level, "Expected game to be \(expectedGame), but got \(game).", file: file, line: line)
	}

	func createTemporaryFile(with data: Data) -> URL {
		let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		FileManager.default.createFile(atPath: url.path, contents: data)
		return url
	}
}
