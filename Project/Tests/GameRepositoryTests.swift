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

	func test_getSavedGame_forTheFirstRun_shouldReturnNewGame() {
		let game = sut.getSavedGame(from: Endpoints.gameUrl)

		assert(game: game)
	}

	func test_getSavedGame_withWrongUrl_shouldReturnNewGame() {
		let wrongUrl = URL(string: "")
		let game = sut.getSavedGame(from: wrongUrl)

		assert(game: game)
	}

	func test_getSavedGame_shouldReturnSavedGame() {
		let savedGame = Game(
			level: Level(id: 1, cellsMatrix: [[0, 1], [1, 0]]),
			taps: 1,
			levels: [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		)
		let savedGameData = try! JSONEncoder().encode(savedGame)
		let savedgameUrl = createTemporaryFile(with: savedGameData)

		let game = sut.getSavedGame(from: savedgameUrl)

		XCTAssertEqual(game, savedGame)
	}
}

private extension GameRepositoryTests {
	func assert(
		game: Game,
		file: StaticString = #file,
		line: UInt = #line
	) {
		let expectedGame = Game(
			level: Level(id: 0, cellsMatrix: [[0]]),
			taps: 0,
			levels: [
				Level(
					id: 0,
					cellsMatrix: [
						[0]
					]
				),
				Level(
					id: 1,
					cellsMatrix: [
						[0, 0],
						[1, 0]
					]
				),
				Level(
					id: 2,
					cellsMatrix: [
						[0, 0],
						[1, 1]
					]
				),
				Level(
					id: 3,
					cellsMatrix: [
						[1, 0],
						[1, 1]
					]
				),
				Level(
					id: 4,
					cellsMatrix: [
						[1, 0, 0, 0],
						[0, 1, 1, 0],
						[0, 1, 1, 0],
						[0, 0, 0, 1]
					]
				),
				Level(
					id: 5,
					cellsMatrix: [
						[1, 1, 1, 1],
						[1, 0, 0, 1],
						[1, 0, 0, 1],
						[1, 1, 1, 1]
					]
				)
			]
		)

		XCTAssertEqual(game.level, expectedGame.level, file: file, line: line)
	}

	func createTemporaryFile(with data: Data) -> URL {
		let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		FileManager.default.createFile(atPath: url.path, contents: data)
		return url
	}
}
