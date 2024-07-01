//
//  Array+sortedById.swift
//  Monochrome
//
//  Created by Alexey Turulin on 7/1/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

extension Array where Element == Level {
	func sortedById() -> [Level] {
		self.sorted { $0.id < $1.id }
	}
}
