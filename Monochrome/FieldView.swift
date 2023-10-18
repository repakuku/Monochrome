//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 10/5/23.
//

import SwiftUI

struct FieldView: View {
    @Binding var field: [[Int]]

    let firstColor: String
    let secondColor: String

    @State private var alertPresented = false

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<field.count, id: \.self) { x in
                HStack(spacing: 2) {
                    ForEach(0..<field.count, id: \.self) { y in
                        Color(field[x][y] == 0 ? secondColor : firstColor)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                            .onTapGesture {
                                changeColor(x: x, y: y)
                            }
                    }
                }
            }
        }
        .frame(width: 350, height: 350)
        .alert("Complete!", isPresented: $alertPresented, actions: {})
    }

    private func changeColor(x: Int, y: Int) {
        for index in 0..<field.count {
            field[x][index] = 1 - field[x][index]
            field[index][y] = 1 - field[index][y]
        }
        field[x][y] = 1 - field[x][y]
    }
}

#Preview {
    FieldView(field: .constant([[0, 1], [1, 0]]), firstColor: "Main", secondColor: "Minor")
}
