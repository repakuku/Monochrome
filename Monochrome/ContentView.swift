//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var size = 10
    @State private var field: [[Int]] = []

    var body: some View {
        ZStack {
            Color(uiColor: .darkGray)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Monochrome")
                    .foregroundStyle(.white)
                    .font(.title)
                
                FieldView(field: $field)
                
                HStack(alignment: .center) {
                    Button("-") {
                        size -= size == 2 ? 0 : 2
                    }
                    .disabled(size == 2)
                    .opacity(size == 2 ? 0.3 : 1)
                    .font(.system(size: 100))
                    .foregroundStyle(size == 2 ? .black : .white)
                    
                    Text("\(size)x\(size)")
                        .font(.system(size: 80))
                        .frame(width: 240)
                        .opacity(0.8)
                    
                    Button("+") {
                        size += size == 10 ? 0 : 2
                    }
                    .disabled(size == 10)
                    .opacity(size == 10 ? 0.3 : 1)
                    .font(.system(size: 100))
                    .foregroundStyle(size == 10 ? .black : .white)
                }
                .foregroundStyle(.white)
                .animation(.default, value: size)
                
                
                Button("Start New Game") {
                    withAnimation {
                        startNewGame(withFieldSize: size)
                    }
                }
                .foregroundStyle(.white)
                .font(.largeTitle)
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
