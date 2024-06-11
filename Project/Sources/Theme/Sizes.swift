//
//  Sizes.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/14/23.
//

import Foundation

// swiftlint:disable type_name
enum Sizes {
	enum General {
		static let roundedViewLength: CGFloat = 56
		static let roundedRectRadius: CGFloat = 15

		static let roundedRectViewWidth: CGFloat = 68
		static let roundedRectViewHeight: CGFloat = 56
	}

	enum Stroke {
		static let width: CGFloat = 2
	}

	enum Spacing {
		static let normal: CGFloat = 5
	}

	enum Kerning {
		static let small: CGFloat = -0.2
		static let normal: CGFloat = 1.5
	}

	enum Background {
		static let initialSquareSize = 100
		static let strokeWidth: CGFloat = 20
		static let roundedRectRadius: CGFloat = 25
	}
}
// swiftlint:enable type_name
