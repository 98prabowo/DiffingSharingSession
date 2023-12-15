//
//  UICollectionView+Diff.swift
//  DiffingSharingSession
//
//  Created by Dimas Agung Prabowo on 16/12/23.
//

import UIKit

extension UICollectionView {
    func apply(
        updates: [IndexPath],
        deletions: [IndexPath],
        insertions: [IndexPath],
        moves: [(from: IndexPath, to: IndexPath)],
        completion: (() -> Void)?
    ) {
        let group = DispatchGroup()
        group.enter()
        
        performBatchUpdates { [weak self] in
            guard let self else { return }
            
            self.deleteItems(at: deletions)
            self.insertItems(at: insertions)
            
            for move in moves {
                self.moveItem(at: move.from, to: move.to)
            }
        } completion: { _ in
            group.leave()
        }

        group.enter()
        
        performBatchUpdates { [weak self] in
            guard let self else { return }
            self.reloadItems(at: updates)
        } completion: { _ in
            group.leave()
        }

        group.notify(queue: .main) {
            completion?()
        }
    }
}
