//
//  Colors.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/7/23.
//

import UIKit

enum Colors {

	// Whites
	static let softWhite = UIColor(hex: 0xEFEFEF)

	// Blacks
	static let softBlack = UIColor(hex: 0x191919)

	enum Red {
		static let Valencia = UIColor(hex: 0xCC4846)
		static let Cinnabar = UIColor(hex: 0xDC5047)
	}
}

enum Theme {

	// Background Color
	static let backgroundColor = UIColor.color(light: Colors.softWhite, dark: Colors.softBlack)

	// Text Color
	static let textColor = UIColor.color(light: Colors.softBlack, dark: Colors.softWhite)

	// Button Colors
	static let buttonStrokeColor = UIColor.color(light: Colors.softBlack, dark: Colors.softWhite)
	static let buttonFilledTextColor = UIColor.color(light: Colors.softWhite, dark: Colors.softBlack)
	static let buttonFilledBackgroundColor = UIColor.color(light: Colors.softBlack, dark: Colors.softWhite)

	// Cell Colors
	static let mainCellColor = UIColor.color(light: Colors.softWhite, dark: Colors.softBlack)
	static let accentCellColor = UIColor.color(light: Colors.softBlack, dark: Colors.softWhite)
	static let hintCellColor = UIColor.color(light: Colors.Red.Cinnabar, dark: Colors.Red.Valencia)
}
