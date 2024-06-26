//
//  TextViews.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct LabelText: View {
	let title: String

	var body: some View {
		Text(title.uppercased())
			.kerning(Sizes.Kerning.normal)
			.font(.caption)
			.bold()
			.foregroundStyle(Color(Theme.textColor))
	}
}

struct InstructionText: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.normal)
			.font(.title3)
			.foregroundStyle(Color(Theme.textColor))
			.multilineTextAlignment(.center)
	}
}

struct BodyText: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.normal)
			.foregroundStyle(Color(Theme.textColor))
			.multilineTextAlignment(.center)
	}
}

struct ButtonTextStroked: View {
	let text: String

	var body: some View {
		Text(text)
			.bold()
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color(Theme.backgroundColor))
			.foregroundColor(Color(Theme.textColor))
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct ButtonTextFilled: View {
	let text: String
	let backgroundColor: Color
	let foregroundColor: Color

	var body: some View {
		Text(text)
			.bold()
			.padding()
			.frame(maxWidth: .infinity)
			.background(backgroundColor)
			.foregroundColor(foregroundColor)
			.cornerRadius(Sizes.General.cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct BigBoldText: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.large)
			.foregroundStyle(Color(Theme.textColor))
			.font(.largeTitle)
			.frame(height: Sizes.General.roundedViewLength)
	}
}

 struct TapsText: View {
	let value: Int

	var body: some View {
		Text(String(value))
			.bold()
			.foregroundColor(Color(Theme.textColor))
			.font(.title3)
	}
 }

struct TapsView: View {
	@Binding var taps: Int

	var body: some View {
		ZStack {
			Text(String(taps))
				.kerning(Sizes.Kerning.large)
				.foregroundStyle(Color(Theme.textColor))
				.font(.largeTitle)
				.frame(
					height: Sizes.General.roundedViewLength
				)
				.transition(
					AnyTransition.asymmetric(
						insertion: .move(edge: .top),
						removal: .move(edge: .bottom)
					)
				)
			.id("Taps" + "\(taps)")
		}
		.frame(height: Sizes.General.roundedViewLength)
		.clipped()
	}
}

struct TextViewsPreviews: View {
	var body: some View {
		VStack {
			LabelText(title: "Score")
			InstructionText(text: "Tap on any cell")
			BodyText(text: "Message")
			ButtonTextStroked(text: "Replay")
			ButtonTextFilled(
				text: "Next Level",
				backgroundColor: Color(Theme.buttonFilledBackgroundColor),
				foregroundColor: Color(Theme.buttonFilledTextColor)
			)
			ButtonTextFilled(
				text: "Next Level",
				backgroundColor: Color(Theme.buttonFilledBackgroundColorRed),
				foregroundColor: Color(Theme.redButtonFilledTextColor)
			)
			BigBoldText(text: "Levels")
			TapsText(value: 33)
		}
	}
}

#Preview {
	TextViewsPreviews()
		.padding()
}
