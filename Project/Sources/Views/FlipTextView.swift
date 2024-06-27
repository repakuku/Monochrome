//
//  FlipTextView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/27/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct FlipTextView: View {
	@State private var nextValue = 0
	@State private var currentValue = 0
	@State private var rotation: CGFloat = 0

	@Binding var value: Int

	let foreground = Color(Theme.buttonFilledTextColor)
	let background = Color(Theme.buttonFilledBackgroundColor)
	let animationDuration: CGFloat = 0.4

	var body: some View {
		if #available(iOS 17.0,	*) {
			let halfHeight = Sizes.General.roundedViewLength * 0.5
			ZStack {
				UnevenRoundedRectangle(
					topLeadingRadius: Sizes.General.cornerRadius,
					bottomLeadingRadius: 0,
					bottomTrailingRadius: 0,
					topTrailingRadius: Sizes.General.cornerRadius
				)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.overlay(alignment: .top) {
					TextView(nextValue)
						.frame(
							width: Sizes.General.roundedViewLength,
							height: Sizes.General.roundedViewLength
						)
						.drawingGroup()
				}
				.clipped()
				.frame(maxHeight: .infinity, alignment: .top)

				UnevenRoundedRectangle(
					topLeadingRadius: Sizes.General.cornerRadius,
					bottomLeadingRadius: 0,
					bottomTrailingRadius: 0,
					topTrailingRadius: Sizes.General.cornerRadius
				)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.modifier(
					RotationModifier(
						rotation: rotation,
						currentValue: currentValue,
						nextValue: nextValue,
						foreground: foreground
					)
				)
				.clipped()
				.rotation3DEffect(
					.init(degrees: rotation),
					axis: (x: 1.0, y: 0.0, z: 0.0),
					anchor: .bottom,
					anchorZ: 0,
					perspective: 0.4
				)
				.frame(maxHeight: .infinity, alignment: .top)
				.zIndex(10)

				UnevenRoundedRectangle(
					topLeadingRadius: 0,
					bottomLeadingRadius: Sizes.General.cornerRadius,
					bottomTrailingRadius: Sizes.General.cornerRadius,
					topTrailingRadius: 0
				)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.overlay(alignment: .bottom) {
					TextView(currentValue)
						.frame(
							width: Sizes.General.roundedViewLength,
							height: Sizes.General.roundedViewLength
						)
						.drawingGroup()
				}
				.clipped()
				.frame(maxHeight: .infinity, alignment: .bottom)
			}
			.frame(
				width: Sizes.General.roundedViewLength,
				height: Sizes.General.roundedViewLength
			)
			.onChange(of: value, initial: true) { oldValue, newValue in
				currentValue = oldValue
				nextValue = newValue

				guard rotation == 0 else {
					currentValue = newValue
					return
				}

				guard oldValue != newValue else { return }

				withAnimation(.easeInOut(duration: animationDuration), completionCriteria: .logicallyComplete) {
					rotation = -180
				} completion: {
					rotation = 0
					currentValue = value
				}
			}
		} else {
			RoundedTextView(text: "\(value)", isFilled: false)
		}
	}

	@ViewBuilder
	func TextView(_ value: Int) -> some View { // swiftlint:disable:this identifier_name
		Text("\(value)")
			.font(.title)
			.foregroundStyle(foreground)
			.lineLimit(1)
	}
}

struct RotationModifier: ViewModifier, Animatable {
	var rotation: CGFloat
	let currentValue: Int
	let nextValue: Int
	let foreground: Color

	var animatableData: CGFloat {
		get { rotation }
		set { rotation = newValue }
	}

	func body(content: Content) -> some View {
		content
			.overlay(alignment: .top) {
				Group {
					if -rotation > 90 {
						Text("\(nextValue)")
							.font(.title)
							.foregroundStyle(foreground)
							.scaleEffect(x: 1.0, y: -1.0)
							.transition(.identity)
							.lineLimit(1)
					} else {
						Text("\(currentValue)")
							.font(.title)
							.foregroundStyle(foreground)
							.transition(.identity)
							.lineLimit(1)
					}
				}
				.frame(
					width: Sizes.General.roundedViewLength,
					height: Sizes.General.roundedViewLength
				)
				.drawingGroup()
			}
	}
}

#Preview {
	FlipTextView(value: .constant(13))
}
