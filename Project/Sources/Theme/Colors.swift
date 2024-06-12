//
//  Colors.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/7/23.
//

import UIKit

enum Colors {
	enum White {
		static let Soft = UIColor(hex: 0xF3F8FD)
	}

	enum Black {
		static let Soft = UIColor(hex: 0x191919)
	}
}

enum Theme {
	static let backgroundColor = UIColor.color(light: Colors.White.Soft, dark: Colors.Black.Soft)

	static let textColor = UIColor.color(light: Colors.Black.Soft, dark: Colors.White.Soft)

	static let buttonStrokeColor = UIColor.color(light: Colors.Black.Soft, dark: Colors.White.Soft)
	static let buttonFilledTextColor = UIColor.color(light: Colors.White.Soft, dark: Colors.Black.Soft)
	static let buttonFilledBackgroundColor = UIColor.color(light: Colors.Black.Soft, dark: Colors.White.Soft)

	static let mainCellColor = UIColor.color(light: Colors.White.Soft, dark: Colors.Black.Soft)
	static let accentCellColor = UIColor.color(light: Colors.Black.Soft, dark: Colors.White.Soft)
}
