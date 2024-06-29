//
//  HashService.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/28/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import CryptoKit

final class HashService {
	static func calculateHash(of data: Data) -> String {
		let hash = SHA256.hash(data: data)
		return hash.map { String(format: "%02hhx", $0) }.joined()
	}
}
