//
//  LoginView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject var userManager: UserManager
	@State var email = ""
	@State var password = ""

	var body: some View {
		VStack {
			MonochromeLabelView()
			Spacer()
			TextField("Email", text: $email)
				.keyboardType(.emailAddress)
			SecureField("Password", text: $password)
			Button("Login") {
				Task {
					await userManager.signIn(email: email, password: password)
				}
			}
			Spacer()
		}
	}
}

#Preview {
	LoginView()
}
