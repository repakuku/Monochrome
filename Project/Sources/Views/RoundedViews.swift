//
//  RoundedViews.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct RoundedImageView: View {
	let systemName: String
	let isFilled: Bool

	var body: some View {
		Image(systemName: systemName)
			.font(.title)
			.foregroundStyle(isFilled ? Color(Theme.buttonFilledTextColor) : Color(Theme.textColor))
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.background(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(isFilled ? Color(Theme.buttonFilledBackgroundColor) : Color.clear)
			)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.strokeBorder(
						Color(Theme.buttonStrokeColor),
						lineWidth: isFilled ? 0 : Sizes.Stroke.width
					)
			)
	}
}

struct RoundedTextView: View {
	let text: String
	let isFilled: Bool

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.small)
			.bold()
			.font(.title3)
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.foregroundStyle(isFilled ? Color(Theme.buttonFilledTextColor) : Color(Theme.textColor))
			.background(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(isFilled ? Color(Theme.buttonFilledBackgroundColor) : Color.clear)
			)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: isFilled ? 0 : Sizes.Stroke.width)
					.foregroundStyle(isFilled ? Color.clear : Color(Theme.buttonStrokeColor))
			)
	}
}

struct RoundedViewsPreview: View {
	var body: some View {
		VStack {
			RoundedImageView(systemName: Images.questionmark.rawValue, isFilled: false)
			RoundedImageView(systemName: Images.checklist.rawValue, isFilled: true)
			RoundedTextView(text: "1", isFilled: false)
			RoundedTextView(text: "2", isFilled: true)
		}
	}
}

#Preview {
	RoundedViewsPreview()
}
