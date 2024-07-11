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
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(Theme.foregroundColor)
					.frame(
						width: Sizes.General.roundedViewLength,
						height: Sizes.General.roundedViewLength
					)
					.offset(y: 4)

				Image(systemName: systemName)
					.font(.title)
					.frame(
						width: Sizes.General.roundedViewLength,
						height: Sizes.General.roundedViewLength
					)
					.background(
						RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
							.fill(
								isFilled
								? Theme.foregroundColor
								: Theme.backgroundColor
							)
					)
					.foregroundStyle(
						isFilled
						? Theme.backgroundColor
						: Theme.foregroundColor
					)
					.overlay(
						RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
							.stroke(lineWidth: Sizes.Stroke.width)
					)
					.zIndex(1)
					.offset(y: isPressed ? 4 : 0)
			}
		}
		.buttonStyle(ClearButtonStyle())
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

struct RoundedCellView: View {
	let color: Color
	let isFilled: Bool
	let action: () -> Void

	@State private var isPressed = false

	var body: some View {
		Button {
			action()
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(color)
					.frame(
						width: Sizes.General.roundedViewLength,
						height: Sizes.General.roundedViewLength
					)
					.offset(y: 4)

				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: isFilled ? 0 : Sizes.Stroke.width)
					.frame(
						width: Sizes.General.roundedViewLength,
						height: Sizes.General.roundedViewLength
					)
					.foregroundStyle(color)
					.background(
						RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
							.fill(isFilled ? color : Theme.backgroundColor)
					)
					.zIndex(1)
					.offset(y: isPressed ? (isFilled ? 2 : 4) : 0)
					.offset(y: isFilled ? 2 : 0)
			}
		}
		.buttonStyle(ClearButtonStyle())
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
			.foregroundStyle(isFilled ? Theme.backgroundColor : Theme.foregroundColor)
			.background(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(isFilled ? Theme.foregroundColor : Theme.backgroundColor)
			)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: isFilled ? 0 : Sizes.Stroke.width)
					.foregroundStyle(isFilled ? .clear : Theme.foregroundColor)
			)
	}
}

struct ClearButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
	}
}

struct RoundedViewsPreview: View {
	var body: some View {
		VStack {
			RoundedImageView(systemName: Images.questionmark.rawValue, isFilled: false, action: {})
			RoundedImageView(systemName: Images.checklist.rawValue, isFilled: true, action: {})
			RoundedCellView(color: Theme.foregroundColor, isFilled: true, action: {})
			RoundedCellView(color: Theme.foregroundColor, isFilled: false, action: {})
			RoundedCellView(color: Theme.accentColor, isFilled: true, action: {})
			RoundedCellView(color: Theme.accentColor, isFilled: false, action: {})
			RoundedTextView(text: "1", isFilled: false)
			RoundedTextView(text: "2", isFilled: true)
		}
	}
}

#Preview {
	RoundedViewsPreview()
}
