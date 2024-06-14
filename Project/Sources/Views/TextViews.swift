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
			.frame(height: 40)
	}
}

struct InstructionText: View {
	let text: String

	var body: some View {
		Text(text)
			.kerning(Sizes.Kerning.normal)
			.font(.title3)
			.foregroundStyle(Color(Theme.textColor))
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
				Color(Theme.hintColor)
			)
			.foregroundColor(
				Color(Theme.textColor)
			)
			.cornerRadius(Sizes.General.roundedRectRadius)
			.overlay(
				RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
					.stroke(lineWidth: Sizes.Stroke.width)
					.foregroundStyle(Color(Theme.buttonStrokeColor))
			)
	}
}

struct TextViewsPreviews: View {
	var body: some View {
		VStack {
			LabelText(title: "Score")
			InstructionText(text: "Tap on any cell")
			BodyText(text: "Message")
			ButtonTextFilled(text: "Next Level")
		}
	}
}

#Preview {
	TextViewsPreviews()
		.padding()
}
