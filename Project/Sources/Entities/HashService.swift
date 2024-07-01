//
//  HashService.swift
//  Monochrome
//
//  Created by Alexey Turulin on 7/1/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import CryptoKit

enum HashService {
	static func calculateHash(of levels: [Level]) -> String {
		let sortedLevels = levels.sortedById()
		let encoder = JSONEncoder()
		encoder.outputFormatting = .sortedKeys

		if let data = try? encoder.encode(sortedLevels) {
			return self.calculateHash(of: data)
		}

		return ""
	}

	private static func calculateHash(of data: Data) -> String {
		let hash = SHA256.hash(data: data)
		return hash.map { String(format: "%02hhx", $0) }.joined()
	}
}
