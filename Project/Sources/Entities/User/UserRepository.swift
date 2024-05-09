//
//  UserRepository.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/8/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

protocol IUserRepository {
	func save(user: User)
	func getUser() -> User?
	func deleteUser()
}

final class UserRepository: IUserRepository {

	@AppStorage("userData") private var userData: Data?

	func save(user: User) {
		userData = try? JSONEncoder().encode(user)
	}

	func getUser() -> User? {
		guard let userData else { return nil }
		let user = try? JSONDecoder().decode(User.self, from: userData)
		guard let user = user else { return nil }
		return user
	}

	func deleteUser() {
		userData = nil
	}
}
