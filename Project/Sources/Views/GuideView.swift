//
//  GuideView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/21/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct GuideView: View {
	@Binding var viewisShowing: Bool

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.ignoresSafeArea()
			VStack {
				HeaderView(viewIsShowing: $viewisShowing)
				Spacer()
				BodyText(text: "In Monochrome, your goal is to make all cells the same color by tapping to flip their colors. Each tap affects the selected cell and its row and column. Solve each puzzle with the fewest taps. \n\nGood luck!") // swiftlint:disable:this line_length
					.padding()
				Spacer()
			}
		}
	}
}

#Preview {
	GuideView(viewisShowing: .constant(true))
}
