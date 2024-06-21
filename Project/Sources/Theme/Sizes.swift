//
//  Sizes.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/14/23.
//

import Foundation

enum Sizes {
	enum General {
		static let roundedViewLength: CGFloat = 56
		static let roundedRectRadius: CGFloat = 15
	}

	enum Field {
		static let roundedRectRadius: CGFloat = 25
	}

	enum Levels {
		static let targetColumnWidth: CGFloat = 60
		static let tapsColumnWidth: CGFloat = 170
		static let maxRowWidth: CGFloat = 480
		static let minRowHeight: CGFloat = 60
	}

	enum Background {
		static let initialSquareSize = 100
		static let strokeWidth: CGFloat = 20
		static let roundedRectRadius: CGFloat = 25
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
		static let large: CGFloat = 2
	}

	enum Padding {
		static let large: CGFloat = 300
	}

	enum Transition {
		static let normalOffset: CGFloat = 100
		static let largeOffset: CGFloat = 300
	}
}
