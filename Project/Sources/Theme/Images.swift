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
	case questionmark
	case checklist
	case xmark
	case star
	case starFilled
	case book

	var description: String {
		switch self {
		case .arrow:
			return "arrow.counterclockwise"
		case .list:
			return "list.dash"
		case .questionmark:
			return "questionmark"
		case .checklist:
			return "checklist"
		case .xmark:
			return "xmark"
		case .star:
			return "star"
		case .starFilled:
			return "star.fill"
		case .book:
			return "book"
		}
	}
}
