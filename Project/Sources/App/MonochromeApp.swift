//
//  MonochromeApp.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

@main
struct MonochromeApp: App {
	@StateObject private var userManager = UserManager()

    var body: some Scene {
        WindowGroup {
            RootView()
				.environmentObject(userManager)
        }
    }
}
