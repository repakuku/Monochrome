//
//  ResultView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ResultView: View {
	@Binding var alertIsVisible: Bool
	var body: some View {
		VStack {
			InstructionText(text: "Level completed!")
			BodyText(text: "What would you do next?")
			Button {
				alertIsVisible = false
			} label: {
				ButtonText(text: "Play Again")
			}
		}
		.frame(width: 300)
		.background(
			Color(Theme.backgroundColor)
		)
		.clipShape(
			RoundedRectangle(cornerRadius: 20)
		)
		.shadow(radius: 10, x: 5, y: 5)
	}
}

#Preview {
	ResultView(alertIsVisible: .constant(true))
}
