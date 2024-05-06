//
//  MonochromeLabelView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 11/9/23.
//

import SwiftUI

struct MonochromeLabelView: View {
	var body: some View {
		Text("Monochrome")
			.foregroundStyle(Color(Theme.mainColor))
			.font(.title)
	}
}

#Preview {
	MonochromeLabelView()
}
