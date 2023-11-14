//
//  Sizes.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/14/23.
//

import Foundation

enum GameSizes {
	static let backgroundOpacity = 0.6
	static let verticalStackSpacing = 30.0

	enum FieldView {
		static let stackSpacing = 2.0
		static let cornerRadius = 10
		static let frameSize = 350.0
		static let shadowRadius = 5.0
		static let shadowOffset = 20.0
	}

	enum SizeView {
		static let width: CGFloat = 240
		static let minOpacity = 0.4
		static let maxOpacity = 1.0
		static let textFontSize: CGFloat = 80
		static let buttonFontSize: CGFloat = 100
	}
}
