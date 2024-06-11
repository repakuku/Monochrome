//
//  Colors.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/7/23.
//

import UIKit

enum Colors {

	enum White {
		static let soft = UIColor(hex: 0xF3F8FD)
	}

	enum Black {
		static let soft = UIColor(hex: 0x191919)
	}
}

enum Theme {
	static let backgroundColor = UIColor.color(light: Colors.White.soft, dark: Colors.Black.soft)

	static let textColor = UIColor.color(light: Colors.Black.soft, dark: Colors.White.soft)

	static let buttonStrokeColor = UIColor.color(light: Colors.Black.soft, dark: Colors.White.soft)
	static let buttonFilledTextColor = UIColor.color(light: Colors.White.soft, dark: Colors.Black.soft)
	static let buttonFilledBackgroundColor = UIColor.color(light: Colors.Black.soft, dark: Colors.White.soft)
}
