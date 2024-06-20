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
			.font(.subheadline)
			.fontWeight(.semibold)
			.multilineTextAlignment(.center)
			.lineSpacing(12)
	}
}

struct ButtonTextStroked: View {
	let text: String

	var body: some View {
		Text(text)
			.bold()
			.padding()
			.frame(maxWidth: .infinity)
			.background(
				Color(Theme.backgroundColor)
			)
			.foregroundColor(
				Color(Theme.textColor)
			)
			.cornerRadius(12)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct ButtonTextFilled: View {
	let text: String

	var body: some View {
		Text(text)
			.bold()
			.padding()
			.frame(maxWidth: .infinity)
			.background(
				Color(Theme.buttonFilledBackgroundColor)
			)
			.foregroundColor(
				Color(Theme.buttonFilledTextColor)
			)
			.cornerRadius(Sizes.General.roundedRectRadius)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct BigBoldText: View {
	let text: String

	var body: some View {
		Text(text.uppercased())
			.kerning(Sizes.Kerning.large)
			.foregroundStyle(Color(Theme.textColor))
			.font(.largeTitle)
	}
}

struct TapsText: View {
	let value: Int

	var body: some View {
		Text(String(value))
			.bold()
			.kerning(-0.2)
			.foregroundColor(Color(Theme.textColor))
			.font(.title3)
	}
}

struct TextViewsPreviews: View {
	var body: some View {
		VStack {
			LabelText(title: "Score")
			InstructionText(text: "Tap on any cell")
			BodyText(text: "Message")
			ButtonTextFilled(text: "Next Level")
			BigBoldText(text: "Levels")
			TapsText(value: 3)
		}
	}
}

#Preview {
	TextViewsPreviews()
		.padding()
}
