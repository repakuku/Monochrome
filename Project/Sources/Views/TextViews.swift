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

struct TextViewsPreviews: View {
	var body: some View {
		VStack {
			LabelText(title: "Score")
		}
	}
}

#Preview {
	TextViewsPreviews()
}
