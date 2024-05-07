//
//  RootView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct RootView: View {
	@EnvironmentObject private var userManager: UserManager

	var body: some View {
		Group {
			if userManager.user.isRegistered {
				GameView()
			} else {
				LoginView()
			}
		}
	}
}

#Preview {
	RootView()
}
