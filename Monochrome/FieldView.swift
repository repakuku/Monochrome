//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/5/23.
//

import SwiftUI

struct FieldView: View {
	@Binding var field: [[Int]]
	@Binding var alertPresented: Bool

	let majorColor: String
	let minorColor: String

	var body: some View {
		VStack(spacing: 2) {
			ForEach(0..<field.count, id: \.self) { x in
				HStack(spacing: 2) {
					ForEach(0..<field.count, id: \.self) { y in
						Color(field[x][y] == 0 ? minorColor : majorColor)
							.clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
							.onTapGesture {
								changeColor(x: x, y: y)
								checkGame()
							}
					}
				}
			}
		}
		.frame(width: 350, height: 350)
	}

	private func changeColor(x: Int, y: Int) {
		for index in 0..<field.count {
			field[x][index] = 1 - field[x][index]
			field[index][y] = 1 - field[index][y]
		}
		field[x][y] = 1 - field[x][y]
	}

	private func checkGame() {
		for row in field {
			if row.contains(0) {
				return
			}
		}

		alertPresented.toggle()
		return
	}
}

#Preview {
	FieldView(
		field: .constant([[0, 1], [1, 0]]),
		alertPresented: .constant(false),
		majorColor: "Major",
		minorColor: "Minor"
	)
}
