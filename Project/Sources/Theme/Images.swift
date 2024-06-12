//
//  Images.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum Images {
	case arrow
	case list

	var description: String {
		switch self {
		case .arrow:
			return "arrow.counterclockwise"
		case .list:
			return "list.dash"
		}
	}
}
