//
//  Endpoints.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/24/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum Endpoints {
	static var documents: URL = {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	}()

	static var gameUrl: URL = {
		URL(
			fileURLWithPath: "Game.json",
			relativeTo: Endpoints.documents
		)
	}()

	static var levelsJsonUrl: URL? = {
		Bundle.main.url(forResource: "Levels", withExtension: "json")
	}()
}
