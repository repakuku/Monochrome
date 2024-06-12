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
		game.field = Field(
			cells: [
				[0, 1, 0, 0],
				[1, 0, 1, 1],
				[0, 1, 0, 1],
				[1, 1, 0, 0]
			]
		)

		let expectedField = Field(
			cells: [
				[1, 0, 1, 1],
				[0, 0, 1, 1],
				[1, 1, 0, 1],
				[0, 1, 0, 0]
			]
		)

		game.toggleColors(atX: 0, atY: 0)

		XCTAssertEqual(game.field.cells, expectedField.cells, "The colors should toggle correctly based on the operation.")
	}

	func testGameRestart() {
		let expectedField = game.field

		game.toggleColors(
			atX: Int.random(in: 0..<game.fieldSize), 
			atY: Int.random(in: 0..<game.fieldSize)
		)
		game.toggleColors(
			atX: Int.random(in: 0..<game.fieldSize),
			atY: Int.random(in: 0..<game.fieldSize)
		)
		game.toggleColors(
			atX: Int.random(in: 0..<game.fieldSize),
			atY: Int.random(in: 0..<game.fieldSize)
		)

		game.restart()
		
		XCTAssertEqual(game.showInstructions, true)
		XCTAssertEqual(game.field.cells, expectedField.cells)
	}
}
