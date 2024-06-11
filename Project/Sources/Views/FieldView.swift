//
//  FieldView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct FieldView: View {
	let size: Int

	var body: some View {
		VStack {
			ForEach(0..<size) { _ in
				HStack {
					ForEach(0..<size) { _ in
						RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
							.frame(
								width: Sizes.General.roundedViewLength,
								height: Sizes.General.roundedViewLength
							)
					}
				}
			}
		}
	}
}

#Preview {
	FieldView(size: 4)
}
