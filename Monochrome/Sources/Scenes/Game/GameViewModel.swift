//
//  GameViewModel.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

import UIKit
import Combine

final class GameViewModel: ObservableObject {

	var objectWillChange = ObservableObjectPublisher()

	var alertPresented = false
	var selectedCell: (x: Int, y: Int)?

	var fieldSize: Int {
		size
	}

	var cellColor: UIColor {
		Theme.mainColor
	}

	var changedCellColor: UIColor {
		Theme.accentColor
	}

	private(set) var game: IGame = Game(field: [])

	private var wrongField = false

	private(set) var size = 2 {
		didSet {
			startNewGame()
		}
	}

	private(set) var minimumSize = 2
	private(set) var maximumSize = 10

	init() {
		startNewGame()
	}

	func decreaseSize() {
		size -= size == 2 ? 0 : 2
	}

	func increaseSize() {
		size += size == 10 ? 0 : 2
	}

	func startNewGame() {
		game = Game(field: createNewField(size: size))
		objectWillChange.send()
		checkGame()
	}

	func getColorForCellAt(x: Int, y: Int) -> UIColor {
		let color = game.field[x][y].value == 0 ? cellColor : changedCellColor
		return color
	}

	func changeColor(x: Int, y: Int) {
		for index in 0..<size {
			game.field[x][index].value = 1 - game.field[x][index].value
			game.field[index][y].value = 1 - game.field[index][y].value
		}
		game.field[x][y].value = 1 - game.field[x][y].value

		checkGame()

		selectedCell = (x, y)

		objectWillChange.send()
	}

	private func createNewField(size: Int) -> [[Cell]] {
		var field = [[Cell]]()

		for row in 0..<size {
			field.append([])
			for _ in 0..<size {
				let cell = Cell(value: Int.random(in: 0...1))
				field[row].append(cell)
			}
		}

		return field
	}

	private func checkGame() {
		for row in game.field where row.contains(where: { $0.value == 0 }) {
			return
		}

		alertPresented.toggle()
	}
}
