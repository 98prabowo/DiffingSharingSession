//
//  Array+Diff.swift
//  DiffingSharingSession
//
//  Created by Dimas Agung Prabowo on 16/12/23.
//

import Foundation

extension Array where Element: Diffable {
    
    /// Calculate the changes between self and the `new` array.
    ///
    /// - Parameters:
    ///   - new: a collection to compare the calee to
    ///   - section: The section in which this diff should be applied to, this is used to create indexPath's. Default is 0
    /// - Returns: A tuple containing the changes.
    public func diffBatch(_ new: [Element], forSection section: Int = 0) -> (updates: [IndexPath], insertions: [IndexPath], deletions: [IndexPath], moves: [(IndexPath, IndexPath)]) {
        let diff = Diff()
        let result = diff.process(old: self, new: new)
        
        var deletions: [IndexPath] = []
        var insertions: [IndexPath] = []
        var updates: [IndexPath] = []
        var moves: [(from: IndexPath, to: IndexPath)] = []
        
        for step in result {
            switch step {
            case let .insert(index, _):
                insertions.append(IndexPath(row: index, section: section))
            case let .delete(index, _):
                deletions.append(IndexPath(row: index, section: section))
            case let .move(from, to, _):
                moves.append((from: IndexPath(row: from, section: section), to: IndexPath(row: to, section: section)))
            case let .update(index, _):
                updates.append(IndexPath(row: index, section: section))
            }
        }
        
        return (updates, insertions, deletions, moves)
    }
    
    public func diff(_ new: [Element]) -> (updates: [Int], insertions: [Int], deletions: [Int], moves: [(Int, Int)]) {
        let diff = Diff()
        let result = diff.process(old: self, new: new)
        
        var deletions: [Int] = []
        var insertions: [Int] = []
        var updates: [Int] = []
        var moves: [(from: Int, to: Int)] = []
        
        for step in result {
            switch step {
            case let .insert(index, _):
                insertions.append(index)
            case let .delete(index, _):
                deletions.append(index)
            case let .move(from, to, _):
                moves.append((from: from, to: to))
            case let .update(index, _):
                updates.append(index)
            }
        }
        
        return (updates, insertions, deletions, moves)
    }
}
