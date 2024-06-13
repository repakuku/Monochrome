//
//  FieldRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class FieldRepository {

	var count: Int {
		fields.count
	}

	private var fields: [Int: Field] = [
		0: Field(
			cells: [
				[0]
			]
		),
		1: Field(
			cells: [
				[0, 0],
				[1, 0]
			]
		),
		2: Field(
			cells: [
				[0, 0],
				[1, 1]
			]
		),
		3: Field(
			cells: [
				[1, 0],
				[1, 1]
			]
		),
		4: Field(
			cells: [
				[0, 0, 0, 0],
				[1, 1, 1, 0],
				[1, 1, 1, 0],
				[1, 1, 1, 0]
			]
		),
		5: Field(
			cells: [
				[0, 0, 0, 0],
				[0, 0, 0, 0],
				[0, 0, 0, 0],
				[0, 0, 0, 0]
			]
		)
	]

	func getField(forLevel level: Int) -> Field {
		guard let field = fields[level] else {
			return Field(cells: [[0]])
		}

		return field
	}
}
