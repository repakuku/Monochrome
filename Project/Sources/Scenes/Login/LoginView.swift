//
//  LoginView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject private var userManager: UserManager

	var body: some View {
		Button("Login") {
			userManager.login()
		}
	}
}

#Preview {
	LoginView()
}
