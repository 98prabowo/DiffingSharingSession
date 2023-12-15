//
//  AnyDiffable.swift
//  DiffingSharingSession
//
//  Created by Dimas Agung Prabowo on 16/12/23.
//

import Foundation

public protocol Diffable: Hashable {
    var primaryKeyValue: String { get }
}

public struct AnyDiffable: Diffable {
    private let _primaryKeyValue: () -> String
    
    var base: AnyHashable
    
    public init(_ base: some Diffable) {
        self.base = base
        _primaryKeyValue = { base.primaryKeyValue }
    }
    
    public static func ==(lhs: AnyDiffable, rhs: AnyDiffable) -> Bool {
        return lhs.base == rhs.base
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_primaryKeyValue())
    }
    
    public var primaryKeyValue: String {
        _primaryKeyValue()
    }
}

extension AnyDiffable {
    
    /// Evaluates the given closure when this `AnyDiffable` instance is type `T`,
    /// passing the unwrapped value as a parameter.
    ///
    /// Use the `map` method with a closure that returns a nonoptional value.
    ///
    /// - Parameter transform: A closure that takes the unwrapped value
    ///   of the instance.
    /// - Returns: The result of the given closure. If this instance is not type T,
    ///   returns `self`.
    func map<T, U>(_ transform: (T) throws -> U) rethrows -> AnyDiffable where T: Diffable, U: Diffable {
        guard let object = base as? T else { return self }
        return try AnyDiffable(transform(object))
    }
    
    /// Evaluates the given closure when this `AnyDiffable` instance is not `nil`,
    /// passing the unwrapped value as a parameter.
    ///
    /// Use the `flatMap` method with a closure that returns an optional value.
    ///
    /// - Parameter transform: A closure that takes the unwrapped value
    ///   of the instance.
    /// - Returns: The result of the given closure. If this instance is `nil`,
    ///   returns `nil`.
    func flatMap<T, U>(_ transform: (T) throws -> U?) rethrows -> AnyDiffable? where T: Diffable, U: Diffable {
        guard let object = base as? T else { return self }
        
        switch try transform(object) {
        case let (wrapped)? where wrapped is AnyDiffable:
            return wrapped as? AnyDiffable
            
        case let (wrapper)?:
            return AnyDiffable(wrapper)
            
        case nil:
            return nil
        }
    }
    
    /// Evaluates the given closure when this `AnyDiffable` instance is not `nil`,
    /// passing the unwrapped value as a parameter.
    ///
    /// Use the `apply` method with an optional closure that returns a nonoptional value.
    ///
    /// - Parameter transform: A closure that takes the unwrapped value
    ///   of the instance.
    /// - Returns: The result of the given closure. If the closure is `nil`,
    ///   returns `nil`.
    func apply<T, U>(_ transform: ((T) throws -> U)?) throws -> AnyDiffable? where T: Diffable, U: Diffable {
        return try transform.flatMap(map)
    }
}
