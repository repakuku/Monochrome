////
////  GameRepositoryTests.swift
////  MonochromeTests
////
////  Created by Alexey Turulin on 6/26/24.
////  Copyright © 2024 repakuku. All rights reserved.
////
//
//import XCTest
//@testable import Monochrome
//
//final class GameRepositoryTests: XCTestCase {
//
//	private var stubLevelRepository: StubLevelRepository!
//	private var sut: GameRepository!
//
//	override func setUp() {
//		super.setUp()
//
//		stubLevelRepository = StubLevelRepository()
//		sut = GameRepository(levelRepository: stubLevelRepository)
//	}
//
//	override func tearDown() {
//		stubLevelRepository = nil
//		sut = nil
//
//		super.tearDown()
//	}
//
//	// MARK: - Get Game
//
//	func test_getGame_forTheFirstRun_shouldReturnNewGame() {
//
//		let expectedGame = createNewGame()
//		let game = sut.getGame()
//
//		XCTAssertEqual(game, expectedGame, "Expected game to be \(expectedGame), but got \(game).")
//	}
//
////	func test_getGame_withInvalidUrl_shouldReturnNewGame() {
////		let invalidUrl = URL(string: "")
////		let game = sut.getGame()
////
////		let expectedGame = createNewGame()
////
////		XCTAssertEqual(game, expectedGame, "Expected game to be \(expectedGame), but got \(game).")
////	}
//
//	func test_getGame__shouldReturnSavedGame() {
//		let savedGame = createSavedGame()
//		
//		let savedGameData = try! JSONEncoder().encode(savedGame)
//		let savedGameUrl = createTemporaryFile(with: savedGameData)
//
//		let game = sut.getGame()
//
//		XCTAssertEqual(game, savedGame, "Expected game to be \(savedGame), but got \(game).")
//	}
//
//	func test_getGame_withChangedOriginLevels_shouldReturnNewGame() {
//		let savedGame = createSavedGame()
//		let savedGameData = try! JSONEncoder().encode(savedGame)
//		let savedgameUrl = createTemporaryFile(with: savedGameData)
//
//		let newOriginLevels = [Level(id: 1, cellsMatrix: [[1, 0], [0, 1]])]
//		stubLevelRepository.levels = newOriginLevels
//
//		let newOriginLevelsHash = HashService.calculateHash(of: newOriginLevels)
//
//		let expectedGame = Game(
//			level: newOriginLevels[0],
//			taps: [],
//			levels: newOriginLevels,
//			originLevels: newOriginLevels,
//			levelsHash: newOriginLevelsHash
//		)
//
//		let game = sut.getGame()
//
//		XCTAssertEqual(game, expectedGame, "Expected game to be \(expectedGame), but got \(game).")
//	}
//
//	// MARK: - Save Game
//
//	func test_saveGame_shouldSaveGame() {
//		let game = createNewGame()
//
//		let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
//
//		sut.saveGame(game)
//
//		XCTAssertTrue(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")
//	}
//
//	func test_saveGame_withNilUrl_shouldNotSaveGame() {
//		let game = createNewGame()
//
//		let nilUrl: URL? = nil
//
//		sut.saveGame(game)
//
//		XCTAssertFalse(FileManager.default.fileExists(atPath: nilUrl?.path ?? ""), "Expected file not to be saved when URL is nil.")
//	}
//
//	// MARK: - Delete Saved Game
//
//	func test_deleteSavedGame_withNilUrl_shouldHandleGracefully() {
//		let game = createNewGame()
//
//		let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
//
//		sut.saveGame(game)
//
//		XCTAssertTrue(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")
//
//		sut.deleteSavedGame()
//
//		XCTAssertFalse(FileManager.default.fileExists(atPath: tempUrl.path), "Expected file to exist at path \(tempUrl.path).")
//	}
//
//	func test_deleteSavedGame_withNilUrl_shouldDeleteGame() {
//		let nilUrl: URL? = nil
//
//		sut.deleteSavedGame()
//
//		XCTAssert(true, "Expected deleteSavedGame to handle nil URL without errors.")
//	}
//}
//
//private extension GameRepositoryTests {
//
//	func createTemporaryFile(with data: Data) -> URL {
//		let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
//		FileManager.default.createFile(atPath: url.path, contents: data)
//		return url
//	}
//
//	func createSavedGame() -> Game {
//		var game = createNewGame()
//
//		game.levels[0].status = .completed(1)
//		game.level = game.levels[1]
//
//		return game
//	}
//
//	func createNewGame() -> Game {
//		let levels = [
//			Level(id: 0, cellsMatrix: [[0]]),
//			Level(id: 1, cellsMatrix: [[0, 0], [1, 0]]),
//			Level(id: 2, cellsMatrix: [[0, 0], [1, 1]]),
//			Level(id: 3, cellsMatrix: [[1, 0], [1, 1]]),
//			Level(id: 4, cellsMatrix: [[1, 0, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 1]]),
//			Level(id: 5, cellsMatrix: [[1, 1, 1, 1], [1, 0, 0, 1], [1, 0, 0, 1], [1, 1, 1, 1]])
//		]
//
//		let levelsHash = HashService.calculateHash(of: levels)
//
//		let game = Game(
//			level: levels[0],
//			taps: [],
//			levels: levels,
//			originLevels: levels,
//			levelsHash: levelsHash
//		)
//
//		return game
//	}
//}
