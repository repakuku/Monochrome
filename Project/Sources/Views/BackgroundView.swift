//
//  BackgroundView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
	var body: some View {
		VStack {
			TopView()
			Spacer()
			BottomView()
		}
		.padding()
		.background(
			Color(Theme.backgroundColor)
		)
	}
}

struct TopView: View {
	var body: some View {
		HStack {
			RoundedImageViewStroked(systemName: Images.arrow.description)
			Spacer()
			RoundedImageViewFilled(systemName: Images.list.description)
		}
	}
}

struct BottomView: View {
	var body: some View {
		HStack {
			NumberView(title: "Score", text: "999")
			Spacer()
			NumberView(title: "Level", text: "1")
		}
	}
}

struct NumberView: View {
	let title: String
	let text: String

	var body: some View {
		HStack {
			VStack(spacing: Sizes.Spacing.normal) {
				LabelText(title: title)
				RoundedRectTextView(text: text)
			}
		}
	}
}

#Preview {
	BackgroundView()
}
