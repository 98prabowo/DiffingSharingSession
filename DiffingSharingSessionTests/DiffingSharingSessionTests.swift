//
//  DiffingSharingSessionTests.swift
//  DiffingSharingSessionTests
//
//  Created by Dimas Agung Prabowo on 16/12/23.
//

import XCTest
@testable import DiffingSharingSession

final class DiffingSharingSessionTests: XCTestCase {

    func testExample() {
         let old = [
            Alphabet(id: "0", char: "Alpha"),
            Alphabet(id: "1", char: "Beta"),
            Alphabet(id: "2", char: "Charlie"),
            Alphabet(id: "3", char: "Delta"),
         ]
        let new = [
            Alphabet(id: "3", char: "Delta"),
            Alphabet(id: "2", char: "Chocolate"), // updates
            Alphabet(id: "1", char: "Beta"),
            Alphabet(id: "5", char: "Echo"),
            Alphabet(id: "6", char: "Foxfort")
         ]
     
         let diff = old.diff(new)
        
         XCTAssertEqual(diff.updates, [1])
         XCTAssertEqual(diff.insertions, [3, 4])
         XCTAssertEqual(diff.deletions, [0])
         let expectedMoves = [(3, 0), (1,2)]
         for (index, move) in diff.moves.enumerated() {
             XCTAssertEqual(move.0, expectedMoves[index].0)
             XCTAssertEqual(move.1, expectedMoves[index].1)
         }
     }

}
