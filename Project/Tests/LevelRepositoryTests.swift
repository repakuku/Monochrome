//
//  LevelRepositoryTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/15/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class LevelRepositoryTests: XCTestCase {

	func test_getLevels_withValidUrlAndJson_shouldReturnCorrectLevels() {
		let sut = makeSut()

		let levels = sut.getLevels()

		let expectedMatrix1 = [[0]]
		let expectedMatrix2 = [
			[0, 0],
			[1, 0]
		]

		XCTAssertEqual(levels.count, 2, "Expected 2 levels, but got \(levels.count)")
		XCTAssertEqual(levels[0].id, 0, "Expected level 0 ID to be 0, but got \(levels[0].id)")
		XCTAssertEqual(levels[1].id, 1, "Expected level 1 ID to be 1, but got \(levels[1].id)")
		XCTAssertEqual(levels[0].cellsMatrix, expectedMatrix1, "Expected level 0 matrix to be \(expectedMatrix1), but got \(levels[0].cellsMatrix)")
		XCTAssertEqual(levels[1].cellsMatrix, expectedMatrix2, "Expected level 1 matrix to be \(expectedMatrix2), but got \(levels[1].cellsMatrix)")
		XCTAssertEqual(levels[0].status, .incompleted, "Expected level 0 status to be incompleted, but got \(levels[0].status)")
		XCTAssertEqual(levels[1].status, .incompleted, "Expected level 1 status to be incompleted, but got \(levels[1].status)")
	}

	func test_getLevels_withInvalidUrl_shouldReturnDefaultLevels() {
		let invalidUrl = URL(string: "")
		let sut = LevelRepository(levelsJsonUrl: invalidUrl)

		let levels = sut.getLevels()

		let expectedMatrix = [[0]]

		XCTAssertEqual(levels.count, 1, "Expected 1 default level, but got \(levels.count)")
		XCTAssertEqual(levels[0].id, 0, "Expected default level ID to be 0, but got \(levels[0].id)")
		XCTAssertEqual(levels[0].cellsMatrix, expectedMatrix, "Expected default level matrix to be \(expectedMatrix), but got \(levels[0].cellsMatrix)")
		XCTAssertEqual(levels[0].status, .incompleted, "Expected default level status to be incompleted, but got \(levels[0].status)")
	}

	func test_getLevels_withInvalidJson_shouldReturnDefaultLevels() {
		let invalidJson = """
		[
			{
				"id": 0,
				"cellsMatrix": "invalid data"
			}
		]
		"""

		let data = invalidJson.data(using: .utf8)!
		let url = createTemporaryFile(with: data)
		let sut = LevelRepository(levelsJsonUrl: url)

		let levels = sut.getLevels()

		let expectedMatrix = [[0]]

		XCTAssertEqual(levels.count, 1, "Expected 1 default level, but got \(levels.count)")
		XCTAssertEqual(levels[0].id, 0, "Expected default level ID to be 0, but got \(levels[0].id)")
		XCTAssertEqual(levels[0].cellsMatrix, expectedMatrix, "Expected default level matrix to be \(expectedMatrix), but got \(levels[0].cellsMatrix)")
		XCTAssertEqual(levels[0].status, .incompleted, "Expected default level status to be incompleted, but got \(levels[0].status)")
	}
}

private extension LevelRepositoryTests {
	func makeSut() -> LevelRepository {
		let json = """
		[
			{
				"id": 0,
				"cellsMatrix": [
					[0]
				],
				"status": {
					"type": "incompleted"
				}
			},
			{
				"id": 1,
				"cellsMatrix": [
					[0, 0],
					[1, 0]
				],
				"status": {
					"type": "incompleted"
				}
			}
		]
		"""

		let data = json.data(using: .utf8)!
		let url = createTemporaryFile(with: data)

		return LevelRepository(levelsJsonUrl: url)
	}

	func createTemporaryFile(with data: Data) -> URL {
		let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
		return url
	}
}
