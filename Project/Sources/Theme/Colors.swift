//
//  Colors.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/7/23.
//

import UIKit

enum Colors {
	static let softWhite = UIColor(hex: 0xEFEFEF)
	static let softBlack = UIColor(hex: 0x191919)

	static let cinnabar = UIColor(hex: 0xDC5047)
	static let wellRead = UIColor(hex: 0xB33234)
}

enum Theme {
	static let foregroundColor = UIColor.color(light: Colors.softBlack, dark: Colors.softWhite)
	static let backgroundColor = UIColor.color(light: Colors.softWhite, dark: Colors.softBlack)
	static let accentColor = UIColor.color(light: Colors.cinnabar, dark: Colors.wellRead)
}
