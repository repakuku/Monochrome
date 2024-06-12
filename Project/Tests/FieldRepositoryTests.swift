//
//  FieldRepositoryTests.swift
//  MonochromeTests
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
@testable import Monochrome

final class FieldRepositoryTests: XCTestCase {
	var sut: FieldRepository!

	override func setUp() {
		super.setUp()
		sut = FieldRepository()
	}

	override func tearDown() {
		sut = FieldRepository()
		super.tearDown()
	}
}
