//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		ZStack {
			BackgroundView()
			FieldView(size: 4)
		}
    }
}

#Preview {
    ContentView()
}
