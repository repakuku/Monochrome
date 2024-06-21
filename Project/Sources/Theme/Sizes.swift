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
		static let alertViewLength: CGFloat = 300
		static let cornerRadius: CGFloat = 15
	}

	enum Levels {
		static let starsColumnWidth: CGFloat = 60
		static let tapsColumnWidth: CGFloat = 170
		static let maxRowWidth: CGFloat = 480
		static let minRowHeight: CGFloat = 60
	}

	enum Kerning {
		static let small: CGFloat = -0.2
		static let normal: CGFloat = 1.5
		static let large: CGFloat = 2
	}

	enum Blur {
		static let min: CGFloat = 0
		static let max: CGFloat = 5
	}

	enum Padding {
		static let large: CGFloat = 300
	}

	enum Shadow {
		static let radius: CGFloat = 10
		static let xOffset: CGFloat = 5
		static let yOffset: CGFloat = 5
	}

	enum Spacing {
		static let small: CGFloat = 5
		static let normal: CGFloat = 10
	}

	enum Stroke {
		static let width: CGFloat = 2
	}
}
