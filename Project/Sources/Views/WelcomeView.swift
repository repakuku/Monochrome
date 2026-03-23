//
//  WelcomeView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 7/11/24.
//  Copyright © 2024 com.repakuku. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {

	@State private var isActive = false

	var body: some View {
		NavigationView {
			ZStack {
				Theme.backgroundColor
					.ignoresSafeArea()

                BigBoldText(text: L10n.WelcomeView.text)

				NavigationLink(
					destination: GameView()
							.transition(.scale),
					isActive: $isActive
				) {
					EmptyView()
				}
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
					isActive = true
				}
			}
		}
	}
}

#Preview {
    WelcomeView()
        .environmentObject(
            GameViewModel(
                gameManager: GameManager(
                    gameRepository: GameRepository(),
                    levelService: LevelService(),
                    levelGenerator: LevelGenerator()
                )
            )
        )
}
