//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var field = [
        [1, 1, 1, 1],
        [0, 0, 0, 1],
        [0, 0, 0, 1],
        [0, 0, 0, 1]
    ]
    @State private var alertPresented = false
    
    private let value = Int.random(in: 0...1)
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            VStack {
                HStack {
                    ColorView(x: 0, y: 0, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 0, y: 1, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 0, y: 2, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 0, y: 3, field: $field, alertPresented: $alertPresented)
                }
                HStack {
                    ColorView(x: 1, y: 0, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 1, y: 1, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 1, y: 2, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 1, y: 3, field: $field, alertPresented: $alertPresented)
                }
                HStack {
                    ColorView(x: 2, y: 0, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 2, y: 1, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 2, y: 2, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 2, y: 3, field: $field, alertPresented: $alertPresented)
                }
                HStack {
                    ColorView(x: 3, y: 0, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 3, y: 1, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 3, y: 2, field: $field, alertPresented: $alertPresented)
                    ColorView(x: 3, y: 3, field: $field, alertPresented: $alertPresented)
                }
            }
            .frame(width: 350, height: 350)
        }
        .alert("Ну ты и индеец! Я балдю! Боом! Бооом!", isPresented: $alertPresented, actions: {})
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ColorView: View {
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
        field.forEach { row in
            if row == [0, 0, 0, 0] {
                alertPresented = true
            } else {
                alertPresented = false
            }
        }
    }
}
