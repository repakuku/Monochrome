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
				RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
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
				RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
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
				width: Sizes.General.roundedRectViewWidth,
				height: Sizes.General.roundedRectViewHeight
			)
			.foregroundStyle(Color(Theme.textColor))
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct RoundedViewsPreview: View {
	var body: some View {
		VStack {
			RoundedImageViewStroked(systemName: Images.arrow.description)
			RoundedImageViewFilled(systemName: Images.list.description)
			RoundedRectTextView(text: "999")
		}
	}
}

#Preview {
	RoundedViewsPreview()
}
