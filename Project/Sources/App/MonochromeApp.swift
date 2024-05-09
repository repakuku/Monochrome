//
//  MonochromeApp.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

@main
struct MonochromeApp: App {
	@StateObject var userManager = UserManager(
		userRepository: UserRepository(),
		authService: MockAuthService()
	)

	var body: some Scene {
		WindowGroup {
			NavigationView {
				RootView()
			}
			.environmentObject(userManager)
		}
	}
}
