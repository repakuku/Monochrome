//
//  GameTests.swift
//  GameTests
//
//  Created by Alexey Turulin on 11/13/23.
//

import XCTest
@testable import Monochrome

final class GameTests: XCTestCase {

	var game: Game!

	override func setUp() {
		super.setUp()
		game = Game()
	}

	override func tearDown() {
		super.tearDown()
		game = nil
	}

	func testColorToggle() {
		game.field = [
			[0, 1, 0, 0],
			[1, 0, 1, 1],
			[0, 1, 0, 1],
			[1, 1, 0, 0]
		]

		let expectedField = [
			[1, 0, 1, 1],
			[0, 0, 1, 1],
			[1, 1, 0, 1],
			[0, 1, 0, 0]
		]

		game.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(game.field, expectedField, "The colors should toggle correctly based on the operation.")
	}
}
