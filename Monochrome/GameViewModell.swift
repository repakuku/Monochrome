//
//  GameViewModel.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

import Foundation

final class GameViewModell: ObservableObject {

	var size: Int {
		game.field.count
	}

	var alertPresented = false

	private let majorColor = "Major"
	private let minorColor = "Minor"
	private let backgroundColor = "Background"

	private var game = Game(field: [])

	func createNewField(withSize size: Int) {
		game = Game(field: [])

		for row in 0..<size {
			game.field.append([])
			for _ in 0..<size {
				let cell = Int.random(in: 0...1)
				game.field[row].append(cell)
			}
		}
	}

	func getColorForCellAt(x: Int, y: Int) -> String {
		let color = game.field[x][y] == 0 ? minorColor : majorColor
		return color
	}

	func changeColor(x: Int, y: Int) {
//		for index in 0..<field.count {
//			field[x][index] = 1 - field[x][index]
//			field[index][y] = 1 - field[index][y]
//		}
//		field[x][y] = 1 - field[x][y]
	}

	func checkGame() {
		for row in game.field {
			if row.contains(0) {
				return
			}
		}

		alertPresented.toggle()
	}
}
