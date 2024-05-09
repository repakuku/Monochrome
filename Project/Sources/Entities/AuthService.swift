//
//  AuthService.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/9/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IAuthService {
	func signIn(email: String, password: String) async -> Result<Void, Error>
	func logout() async -> Result<Void, Error>
}

final class MockAuthService: IAuthService {
	func signIn(email: String, password: String) async -> Result<Void, Error> {
		do {
			try await Task.sleep(nanoseconds: 1_000_000_000)
			return .success(())
		} catch {
			return .failure(error)
		}
	}

	func logout() async -> Result<Void, Error> {
		do {
			try await Task.sleep(nanoseconds: 1_000_000_000)
			return .success(())
		} catch {
			return .failure(error)
		}
	}
}
