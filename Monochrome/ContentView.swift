//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var size = 2
    @State private var field: [[Int]] = []

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Monochrome")
                    .foregroundStyle(.white)
                Spacer()
                FieldView(field: $field)
                Spacer()
                HStack(alignment: .center) {
                    Button(size == 2 ? "" : "-") {
                        size -= size == 2 ? 0 : 2
                    }
                    Text("\(size)x\(size)")
                        .frame(width: 100)
                    Button(size == 10 ? "" : "+") {
                        size += size == 10 ? 0 : 2
                    }
                }
                .font(.largeTitle)
                .foregroundStyle(.white)
                
                Button("Start Game") {
                    withAnimation {
                        startNewGame(withFieldSize: size)
                    }
                }
                .font(.largeTitle)
                .foregroundStyle(.white)
                Spacer()
            }
        }
    }
    
    private func startNewGame(withFieldSize fieldSize: Int) {
        field = []
        
        for row in 0..<fieldSize {
            field.append([])
            for _ in 0..<fieldSize {
                let cell = Int.random(in: 0...1)
                field[row].append(cell)
            }
        }
    }
}

#Preview {
    ContentView()
}
