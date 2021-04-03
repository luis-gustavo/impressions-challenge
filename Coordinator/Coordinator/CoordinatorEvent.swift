//
//  CoordinatorEvent.swift
//  Coordinator
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import Foundation

/// Wrapper of `CoordinatorEvent` to make it equatable and hashable at a type level.
public class CoordinatorEventType: Hashable {
    private let wrapped: CoordinatorEvent.Type

    public init(_ type: CoordinatorEvent.Type) {
        self.wrapped = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(wrapped).hashValue)
    }

    public static func == (lhs: CoordinatorEventType, rhs: CoordinatorEventType) -> Bool {
        return lhs.wrapped == rhs.wrapped
    }
}

/// Defines a event of a coordinator
public protocol CoordinatorEvent {}

public extension CoordinatorEvent {
    var key: CoordinatorEventType { return CoordinatorEventType(type(of: self)) }
    static var key: CoordinatorEventType { return CoordinatorEventType(self) }
}
