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
    
    @State private var gameStarted = false
    
    private let minOpacity = 0.4
    private let maxOpacity = 1.0
    
    private let mainColor = "Main"
    private let minorColor = "Minor"
    private let backgroundColor = "Background"

    var body: some View {
        ZStack {
            Color(backgroundColor)
                .opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Monochrome")
                    .foregroundStyle(Color(mainColor))
                    .font(.title)
                
                Spacer()
                
                FieldView(field: $field, firstColor: mainColor, secondColor: minorColor)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button("-") {
                        size -= size == 2 ? 0 : 2
                    }
                    .disabled(size == 2)
                    .opacity(size == 2 ? minOpacity : maxOpacity)
                    .font(.system(size: 100))
                    .foregroundStyle(size == 2 ? Color(minorColor) : Color(mainColor))
                    
                    Text("\(size)x\(size)")
                        .font(.system(size: 80))
                        .frame(width: 240)
                        .foregroundStyle(Color(mainColor))
                    
                    Button("+") {
                        size += size == 10 ? 0 : 2
                    }
                    .disabled(size == 10)
                    .opacity(size == 10 ? minOpacity : maxOpacity)
                    .font(.system(size: 100))
                    .foregroundStyle(size == 10 ? Color(minorColor) : Color(mainColor))
                }
                .animation(.default, value: size)
                
                Button("Start New Game") {
                    withAnimation {
                        startNewGame(withFieldSize: size)
                    }
                }
                .frame(width: 300, height: 60)
                .foregroundStyle(Color(mainColor))
                .font(.largeTitle)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(mainColor), lineWidth: 3)
                )
            }
            .shadow(radius: 5, x: 0.0, y: 0.0)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1)) {
                startNewGame(withFieldSize: size)
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
