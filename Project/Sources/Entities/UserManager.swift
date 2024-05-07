//
//  UserManager.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class UserManager: ObservableObject {
	@Published var user: User

	init() {
		self.user = User()
	}

	func login() {
		user.isRegistered = true
	}
}
