//
//  GameViewModel.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

import Combine

final class GameViewModell: ObservableObject {

	var objectWillChange = ObservableObjectPublisher()

	var size = 0 {
		didSet {
			createNewField()
		}
	}

	var alertPresented = false

	private let firstColor = "Major"
	private let secondColor = "Minor"

	private var game = Game(field: [])

	func decreaseSize() {
		size -= size == 2 ? 0 : 2
	}

	func increaseSize() {
		size += size == 10 ? 0 : 2
	}

	func createNewField() {
		game.field = []

		for row in 0..<size {
			game.field.append([])
			for _ in 0..<size {
				let cell = Int.random(in: 0...1)
				game.field[row].append(cell)
			}
		}
		objectWillChange.send()
	}

	func getColorForCellAt(x: Int, y: Int) -> String {
		let color = game.field[x][y] == 0 ? secondColor : firstColor
		return color
	}

	func changeColor(x: Int, y: Int) {
		for index in 0..<size {
			game.field[x][index] = 1 - game.field[x][index]
			game.field[index][y] = 1 - game.field[index][y]
		}
		game.field[x][y] = 1 - game.field[x][y]
		objectWillChange.send()
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
