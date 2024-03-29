//
//  GameViewModel.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/19/23.
//

import Combine

final class GameViewModell: ObservableObject {

	var objectWillChange = ObservableObjectPublisher()

	var alertPresented = false

	var fieldSize: Int {
		size
	}

	var cellColor: String {
		GameColors.secondary.rawValue
	}

	var changedCellColor: String {
		GameColors.main.rawValue
	}

	private var game: IGame = Game(field: [])

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
		game = Game(field: [])

		for row in 0..<size {
			game.field.append([])
			for _ in 0..<size {
				let cell = Int.random(in: 0...1)
				game.field[row].append(cell)
			}
		}

		objectWillChange.send()

		checkGame()

		guard !alertPresented else {
			alertPresented.toggle()
			startNewGame()
			return
		}
	}

	func getColorForCellAt(x: Int, y: Int) -> String {
		let color = game.field[x][y] == 0 ? cellColor : changedCellColor
		return color
	}

	func changeColor(x: Int, y: Int) {
		for index in 0..<size {
			game.field[x][index] = 1 - game.field[x][index]
			game.field[index][y] = 1 - game.field[index][y]
		}
		game.field[x][y] = 1 - game.field[x][y]

		checkGame()

		objectWillChange.send()
	}

	private func checkGame() {
		for row in game.field where row.contains(0) {
			return
		}

		alertPresented.toggle()
	}
}
