//
//  HashServiceTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 7/1/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class HashServiceTests: XCTestCase {
	func test_calculateHash_withEqualLevelsData_shouldReturnSameHash() {
		let levels1 = [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		let levels2 = [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]

		let levels1hash = HashService.calculateHash(of: levels1)
		let levels2hash = HashService.calculateHash(of: levels2)

		XCTAssertEqual(levels1hash, levels2hash, "Expected hashes to be equal, but got \(levels1hash) and \(levels2hash).")
	}

	func test_calculateHash_withDifferentLevelsData_shouldReturnDifferentHash() {
		let levels1 = [Level(id: 1, cellsMatrix: [[0, 1], [1, 0]])]
		let levels2 = [Level(id: 1, cellsMatrix: [[1, 0], [0, 1]])]

		let levels1hash = HashService.calculateHash(of: levels1)
		let levels2hash = HashService.calculateHash(of: levels2)

		XCTAssertNotEqual(levels1hash, levels2hash, "Expected hashes to be different, but got \(levels1hash) and \(levels2hash).")
	}
}
