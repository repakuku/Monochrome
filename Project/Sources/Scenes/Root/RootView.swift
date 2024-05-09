//
//  RootView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct RootView: View {
	@EnvironmentObject var userManager: UserManager

	var body: some View {
		Group {
			if userManager.isLoggedIn {
				GameView()
			} else {
				LoginView()
			}
		}
		.environmentObject(userManager)
	}
}

#Preview {
	RootView()
}
