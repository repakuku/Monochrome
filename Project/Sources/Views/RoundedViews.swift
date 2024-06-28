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
	let action: () -> Void

	@State private var isPressed = false

	var body: some View {
		Button {
			action()
		} label: {
			ZStack {
				if !isPressed {
					RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
						.fill(Color(Theme.buttonShadowColor))
						.frame(
							width: Sizes.General.roundedViewLength,
							height: Sizes.General.roundedViewLength
						)
						.offset(x: 3, y: 3)
				}

				Image(systemName: systemName)
					.font(.title)
					.foregroundStyle(isFilled ? Color(Theme.buttonFilledTextColor) : Color(Theme.textColor))
					.frame(
						width: Sizes.General.roundedViewLength,
						height: Sizes.General.roundedViewLength
					)
					.background(
						RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
							.fill(isFilled ? Color(Theme.buttonFilledBackgroundColor) : Color(Theme.backgroundColor))
					)
					.overlay(
						RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
							.strokeBorder(
								Color(Theme.buttonStrokeColor),
								lineWidth: isFilled ? 0 : Sizes.Stroke.width
							)
					)
					.zIndex(1)
					.offset(x: isPressed ? 4 : 0, y: isPressed ? 4 : 0)
					.scaleEffect(CGSize(width: isPressed ? 0.95 : 1, height: isPressed ? 0.95 : 1))
			}
		}
		.buttonStyle(PlainButtonStyle())
		.simultaneousGesture(
			DragGesture(minimumDistance: 0)
				.onChanged { _ in
					isPressed = true
				}
				.onEnded { _ in
					isPressed = false
				}
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
			RoundedImageView(systemName: Images.questionmark.rawValue, isFilled: false, action: {})
			RoundedImageView(systemName: Images.checklist.rawValue, isFilled: true, action: {})
			RoundedTextView(text: "1", isFilled: false)
			RoundedTextView(text: "2", isFilled: true)
		}
	}
}

#Preview {
	RoundedViewsPreview()
}
