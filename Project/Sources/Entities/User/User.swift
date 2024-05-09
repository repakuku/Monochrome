//
//  User.swift
//  Monochrome
//
//  Created by Alexey Turulin on 5/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct User: Codable {
	var id = UUID()
	var email: String
	var isRegistered = false
}
