//
//  RandomSource.swift
//  Monochrome
//
//  Created by Alexey Turulin on 3/17/26.
//  Copyright © 2026 com.repakuku. All rights reserved.
//

protocol IRandomSource {
    func next() -> Int
}

final class RandomSource: IRandomSource {
    func next() -> Int {
        Int.random(in: 0...1)
    }
}

final class StubRandomSource: IRandomSource {
    let values: [Int]
    private var index = 0

    init(values: [Int]) {
        self.values = values
    }

    func next() -> Int {
        let value = values[index % values.count]
        index += 1
        return value
    }
}
