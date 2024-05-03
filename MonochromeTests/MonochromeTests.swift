//
//  MonochromeTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 11/13/23.
//

import XCTest
@testable import Monochrome

final class MonochromeTests: XCTestCase {

	var sut: GameViewModel!

	override func setUp() {
		super.setUp()
		sut = GameViewModel()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testDecreaseSizeShouldReturn2WhenLowestSize() {
		sut.decreaseSize()
		let size = sut.size
		XCTAssert(size == 2, "The lowest size should be equal 2")
	}

	func testIncreaseSizeShouldReturn10WhenHighestSize() {
		for _ in 0...4 {
			sut.increaseSize()
		}
		let size = sut.size
		XCTAssert(size == 10, "The highest size should be equal 10")
	}
}
