//
//  BackgroundView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var viewModel: GameViewModel

    @Binding var isMenuOpen: Bool
    @Binding var activeOverlay: ActiveOverlay

    var body: some View {
        VStack {
            TopView(isMenuOpen: $isMenuOpen)

            Spacer()

            BottomView(
                isMenuOpen: $isMenuOpen,
                activeOverlay: $activeOverlay
            )
        }
        .padding()
    }
}

struct TopView: View {
    @EnvironmentObject var viewModel: GameViewModel

    @Binding var isMenuOpen: Bool

    @State private var menuPhase: MenuPhase = .closed
    @State private var guideViewIsShowing = false

    private enum MenuPhase {
        case closed
        case hintOnly
        case expanded
    }

    var body: some View {
        VStack {
            HStack {
                RoundedImageView(
                    systemName: Images.arrow.rawValue,
                    isFilled: false
                ) {
                    withAnimation {
                        viewModel.restartLevel()
                    }
                    closeMenu()
                }

                Spacer()

                BigBoldText(text: L10n.Level.title(viewModel.levelId))

                Spacer()

                RoundedImageView(
                    systemName: Images.list.rawValue,
                    isFilled: isMenuOpen
                ) {
                    if isMenuOpen {
                        isMenuOpen = false
                    } else {
                        openMenu()
                    }
                }
            }
            .zIndex(2)

            if menuPhase == .hintOnly || menuPhase == .expanded {
                HStack {
                    Spacer()

                    VStack {
                        RoundedImageView(
                            systemName: Images.questionmark.rawValue,
                            isFilled: false
                        ) {
                            withAnimation {
                                viewModel.getHint()
                            }
                            closeMenu()
                        }
                    }
                }
                .zIndex(1)
                .transition(.offset(y: -Sizes.General.roundedViewLength - Sizes.Spacing.small))
            }

            if menuPhase == .expanded {
                HStack {
                    Spacer()

                    RoundedImageView(
                        systemName: Images.book.rawValue,
                        isFilled: false
                    ) {
                        withAnimation {
                            guideViewIsShowing = true
                        }
                        closeMenu()
                    }
                }
                .zIndex(0)
                .transition(.offset(y: -Sizes.General.roundedViewLength - Sizes.Spacing.small))
            }
        }
        .sheet(isPresented: $guideViewIsShowing) {
            GuideView(
                viewModel: viewModel,
                viewisShowing: $guideViewIsShowing
            )
        }
        .onChange(of: isMenuOpen) { isOpen in
            if !isOpen, menuPhase != .closed {
                closeMenu()
            }
        }
    }

    private func openMenu() {
        isMenuOpen = true

        withAnimation {
            menuPhase = .hintOnly
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard isMenuOpen, menuPhase == .hintOnly else { return }

            withAnimation {
                menuPhase = .expanded
            }
        }
    }

    private func closeMenu() {
        withAnimation {
            menuPhase = .hintOnly
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard menuPhase == .hintOnly else { return }

            withAnimation {
                menuPhase = .closed
            }
        }
    }
}

struct BottomView: View {
    @EnvironmentObject var viewModel: GameViewModel

    @Binding var isMenuOpen: Bool
    @Binding var activeOverlay: ActiveOverlay
    @State private var levelsViewIsShowing = false

    var body: some View {
        HStack {
            RoundedImageView(
                systemName: Images.back.rawValue,
                isFilled: false
            ) {
                withAnimation {
                    viewModel.undoButtonTapped()
                }
            }

            Spacer()

            TapsView(taps: $viewModel.taps)

            Spacer()

            RoundedImageView(
                systemName: Images.checklist.rawValue,
                isFilled: false
            ) {
                withAnimation {
                    levelsViewIsShowing = true
                    isMenuOpen = false
                }
            }
        }
        .sheet(isPresented: $levelsViewIsShowing) {
            LevelsView(activeOverlay: $activeOverlay)
        }
    }
}

#Preview {
    BackgroundView(
        isMenuOpen: .constant(true),
        activeOverlay: .constant(.none)
    )
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
