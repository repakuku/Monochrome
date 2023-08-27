//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var size = 4
    @State private var field: [[Int]] = []

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            VStack {
                Button("Start New Game", action: {createField(withSize: size)} )
                    .font(.largeTitle)
                    .foregroundColor(.white)
                FieldView(field: $field)
                HStack {
                    Button("2") {
                        size = 2
                        createField(withSize: size)
                    }
                    Button("4") {
                        size = 4
                        createField(withSize: size)
                    }
                    Button("6") {
                        size = 6
                        createField(withSize: size)
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
            }
        }
    }
    
    private func createField(withSize size: Int) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FieldView: View {
    @Binding var field: [[Int]]

    @State private var alertPresented = false
    
    
    var body: some View {
        VStack {
            
            ForEach(0..<field.count, id: \.self) { x in
                HStack {
                    ForEach(0..<field.count, id: \.self) { y in
                        CellView(x: x, y: y, field: $field, alertPresented: $alertPresented)
                    }
                }
            }
        }
        .frame(width: 350, height: 350)
        .alert("Complete!", isPresented: $alertPresented, actions: {})
    }
}

struct CellView: View {
    let x: Int
    let y: Int
    
    @Binding var field: [[Int]]
    @Binding var alertPresented: Bool
    
    var body: some View {
        Color(UIColor(field[x][y] == 0 ? .white : .black))
            .onTapGesture {
                changeColor(x: x, y: y)
            }
    }
    
    private func changeColor(x: Int, y: Int) {
        for index in 0..<field.count {
            field[x][index] = 1 - field[x][index]
            field[index][y] = 1 - field[index][y]
        }
        field[x][y] = 1 - field[x][y]
        checkField()
    }
    
    private func checkField() {
        var isComplete = true
        
        field.forEach { row in
            if row != [0, 0] {
                isComplete = false
            }
        }
        
        alertPresented = isComplete
    }
}
