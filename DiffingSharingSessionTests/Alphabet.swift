//
//  Alphabet.swift
//  DiffingSharingSessionTests
//
//  Created by Dimas Agung Prabowo on 16/12/23.
//

@testable import DiffingSharingSession

struct Alphabet {
    let id: String
    let char: String
}

extension Alphabet: Diffable {
    var primaryKeyValue: String {
        return id
    }
}
