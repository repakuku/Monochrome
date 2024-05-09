//
//  UserManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

final class UserManager: ObservableObject {
	@Published var isLoggedIn = false

	private var user: User? {
		didSet {
			isLoggedIn = user != nil
		}
	}

	private let userRepository: IUserRepository
	private let authService: IAuthService

	init(userRepository: IUserRepository, authService: IAuthService) {
		self.userRepository = userRepository
		self.authService = authService
		fetchUser()
	}

	func signIn(email: String, password: String) async {
		let result = await authService.signIn(email: email, password: password)

		switch result {
		case .success:
			DispatchQueue.main.async {
				let user = User(email: email)
				self.userRepository.save(user: user)
				self.user = user
			}
		case .failure:
			break
		}
	}

	func logout() async {
		let result = await authService.logout()

		switch result {
		case .success:
			DispatchQueue.main.async {
				self.user = nil
				self.userRepository.deleteUser()
			}
		case .failure:
			break
		}
	}

	private func fetchUser() {
		user = userRepository.getUser()
	}
}
