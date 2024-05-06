//
//  Sizes.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/14/23.
//

import Foundation

enum GameParameters {
	static let backgroundOpacity = 0.6
	static let verticalStackSpacing = 30.0

	enum FieldView {
		static let stackSpacing: CGFloat = 2.0
		static let cornerRadius: CGFloat = 10
		static let frameSize: CGFloat = 350.0
		static let shadowRadius: CGFloat = 5.0
		static let shadowOffset: CGFloat = 20.0
	}

	enum SizeView {
		static let width: CGFloat = 240
		static let minOpacity = 0.4
		static let maxOpacity = 1.0
		static let textFontSize: CGFloat = 80
		static let buttonFontSize: CGFloat = 100
	}

	enum NewGameButtonView {
		static let width: CGFloat = 200
		static let height: CGFloat = 60
		static let cornerRadius: CGFloat = 10
		static let lineWidth: CGFloat = 3
	}
}

// swiftlint:disable type_name
enum Sizes {

	static let cornerRadius: CGFloat = 6
	static let borderWidth: CGFloat = 1

	enum Padding {
		static let micro: CGFloat = 4
		static let small: CGFloat = 8
		static let normal: CGFloat = 16
		static let double: CGFloat = 32
	}

	enum L {
		static let width: CGFloat = 200
		static let height: CGFloat = 50
		static let widthMultiplier: CGFloat = 0.9
		static let icon: CGFloat = 32
	}

	enum M {
		static let width: CGFloat = 100
		static let height: CGFloat = 40
		static let icon: CGFloat = 24
	}

	enum S {
		static let width: CGFloat = 80
		static let height: CGFloat = 30
		static let icon: CGFloat = 16
	}
}
// swiftlint:enable type_name
