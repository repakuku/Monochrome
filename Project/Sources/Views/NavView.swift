//
//  NavView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 7/11/24.
//  Copyright © 2024 com.repakuku. All rights reserved.
//

import SwiftUI

struct NavView: View {
	var body: some View {
		NavigationView {
			NavigationLink {
				GameView()
			} label: {
				Text("Start Game")
			}
		}
	}
}

#Preview {
	NavView()
}
