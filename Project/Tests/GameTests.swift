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
		game = nil
		super.tearDown()
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
		XCTAssertEqual(game.steps, 1)
		XCTAssertEqual(game.showInstructions, false)
	}

	func testColorToggleInvalidCoordinates() {
		game.field = Field(
			cells: [
				[0, 1],
				[1, 0]
			]
		)

		let initialField = game.field

		game.toggleColors(atX: -1, atY: 1)
		XCTAssertEqual(game.field.cells, initialField.cells, "The field should remain unchanged for out-of-bounds X coordinate.")

		game.toggleColors(atX: 1, atY: -1)
		XCTAssertEqual(game.field.cells, initialField.cells, "The field should remain unchanged for out-of-bounds Y coordinate.")

		game.toggleColors(atX: 2, atY: 1)
		XCTAssertEqual(game.field.cells, initialField.cells, "The field should remain unchanged for out-of-bounds X coordinate.")

		game.toggleColors(atX: 1, atY: 2)
		XCTAssertEqual(game.field.cells, initialField.cells, "The field should remain unchanged for out-of-bounds Y coordinate.")
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
		
		XCTAssertFalse(game.showInstructions, "The showInstructions flag should be false after restart.")
		XCTAssertEqual(game.field.cells, expectedField.cells, "The field should be reset to its initial state after restart.")
		XCTAssertEqual(game.steps, 0)
	}

	func testGameCompleted() {
		game.field = Field(
			cells: [
				[0, 0],
				[1, 0]
			]
		)

		game.toggleColors(atX: 0, atY: 1)

		XCTAssertTrue(game.field.isSolved)
	}

	func testGameNext() {

		XCTAssertEqual(game.targetSteps, 1)

		game.nextGame()

		var expectedField = Field(
			cells: [
				[0, 0],
				[1, 0]
			]
		)

		XCTAssertEqual(game.level, 1)
		XCTAssertEqual(game.steps, 0)
		XCTAssertEqual(game.field.cells, expectedField.cells)
		XCTAssertEqual(game.targetSteps, 1)

		game.nextGame()

		expectedField = Field(
			cells: [
				[0, 0],
				[1, 1]
			]
		)

		XCTAssertEqual(game.level, 2)
		XCTAssertEqual(game.field.cells, expectedField.cells)
		XCTAssertEqual(game.targetSteps, 2)
	}

	func testGameMaximumLevel() {
		for _ in 0...6 {
			game.nextGame()
		}

		let expectedField = game.field

		game.nextGame()
		game.nextGame()

		XCTAssertEqual(game.field.cells, expectedField.cells)
	}

	func testGameHint() {

		game.nextGame()

		game.getFieldHint()

		var expectedField = Field(
			cells: [
				[0, 2],
				[1, 0]
			]
		)

		XCTAssertEqual(game.field.cells, expectedField.cells)

		game.toggleColors(atX: 0, atY: 0)
		game.getFieldHint()

		expectedField = Field(
			cells: [
				[3, 1],
				[0, 0]
			]
		)

		XCTAssertEqual(game.field.cells, expectedField.cells)

		game.toggleColors(atX: 1, atY: 0)
		game.getFieldHint()

		expectedField = Field(
			cells: [
				[2, 1],
				[1, 1]
			]
		)

		XCTAssertEqual(game.field.cells, expectedField.cells)

		game.restart()

		game.getFieldHint()

		expectedField = Field(
			cells: [
				[0, 2],
				[1, 0]
			]
		)

		XCTAssertEqual(game.field.cells, expectedField.cells)

		game.restart()
		game.getFieldHint()
		game.getFieldHint()

		expectedField = Field(
			cells: [
				[0, 2],
				[1, 0]
			]
		)

		XCTAssertEqual(game.field.cells, expectedField.cells)
	}
}
