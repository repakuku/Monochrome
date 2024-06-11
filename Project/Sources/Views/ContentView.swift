//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var game = Game()

	var body: some View {
		ZStack {
			BackgroundView(game: $game)
			FieldView(game: $game)
		}
	}
}

#Preview {
	ContentView()
}
