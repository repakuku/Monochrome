//
//  RoundedViews.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct RoundedImageViewStroked: View {
	let systemName: String

	var body: some View {
		Image(systemName: systemName)
			.font(.title)
			.foregroundStyle(Color(Theme.textColor))
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.strokeBorder(
						Color(Theme.buttonStrokeColor),
						lineWidth: Sizes.Stroke.width
					)
			)
	}
}

struct RoundedImageViewFilled: View {
	let systemName: String

	var body: some View {
		Image(systemName: systemName)
			.font(.title)
			.foregroundStyle(Color(Theme.buttonFilledTextColor))
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.background(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(Color(Theme.buttonFilledBackgroundColor))
			)
	}
}

struct RoundedRectTextView: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.small)
			.bold()
			.font(.title3)
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.foregroundStyle(Color(Theme.textColor))
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct RoundedSquareTextView: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.small)
			.bold()
			.font(.title3)
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.foregroundStyle(Color(Theme.textColor))
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: 2)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct RoundedSquareTextViewFilled: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.small)
			.bold()
			.font(.title3)
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.foregroundStyle(Color(Theme.buttonFilledTextColor))
			.background(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(Color(Theme.buttonFilledBackgroundColor))
			)
	}
}

struct RoundedViewsPreview: View {
	var body: some View {
		VStack {
			RoundedImageViewStroked(systemName: Images.arrow.rawValue)
			RoundedImageViewFilled(systemName: Images.list.rawValue)
			RoundedRectTextView(text: "999")
			RoundedSquareTextView(text: "1")
			RoundedSquareTextViewFilled(text: "2")
		}
	}
}

#Preview {
	RoundedViewsPreview()
}
