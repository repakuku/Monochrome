//
//  ContentView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 8/18/23.
//

import SwiftUI

struct GameView: View {
	@StateObject private var viewModel = GameViewModell()

	var body: some View {
		ZStack {
			Color(viewModel.backgroundColor)
				.opacity(0.6)
				.ignoresSafeArea()

			VStack(spacing: 30) {
				MonochromeLabelView(color: viewModel.majorColor)
				Spacer()
				FieldView(viewModel: viewModel)
				Spacer()
				SizeView(viewModel: viewModel)
				NewGameButtonView(viewModel: viewModel)
			}
		}
		.onAppear {
			withAnimation(Animation.easeInOut(duration: 1)) {
				viewModel.startNewGame()
			}
		}
		.alert("Complete!", isPresented: $viewModel.alertPresented) {
			Button("Start new game") {
				withAnimation {
					viewModel.startNewGame()
				}
			}
		}
	}
}

#Preview {
	GameView()
}
