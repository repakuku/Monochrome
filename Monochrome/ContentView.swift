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
                    .opacity(size == 2 ? 0.3 : 0.8)
                    .font(.system(size: 100))
                    
                    Text("\(size)x\(size)")
                        .font(.system(size: 80))
                        .frame(width: 240)
                    
                    Button("+") {
                        size += size == 6 ? 0 : 2
                    }
                    .disabled(size == 6)
                    .opacity(size == 6 ? 0.3 : 0.8)
                    .font(.system(size: 100))
                }
                .foregroundStyle(.white)
                
                
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
