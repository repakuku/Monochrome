//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var size = 0
    @State private var field: [[Int]] = []

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            VStack {
                Spacer()
                FieldView(field: $field)
                Spacer()
                Group {
                    Text(size == 0 ? "" : "\(size)x\(size)")
                    Button(size == 0 || size == 10 ? "New Game" : "Next Game") {
                        size += size == 10 ? 0 : 2
                        createNewField(withSize: size)
                    }
                    Button("Restart") {
                        startNewGame()
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)

            }
        }
    }
    
    private func startNewGame() {
        size = 0
        field = []
    }
    
    private func createNewField(withSize size: Int) {
        field = []

        for row in 0..<size {
            field.append([])
            for _ in 0..<size {
                let cell = Int.random(in: 0...1)
                field[row].append(cell)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct FieldView: View {
    @Binding var field: [[Int]]

    @State private var alertPresented = false
    
    var body: some View {
        VStack {
            ForEach(0..<field.count, id: \.self) { x in
                HStack {
                    ForEach(0..<field.count, id: \.self) { y in
                        Color(field[x][y] == 0 ? .white : .black)
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
