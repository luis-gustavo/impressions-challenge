//
//  BaseCoordinator.swift
//  Coordinator
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import Foundation

/// Base implementation of the `CoordinatorProtocol`.  Sub-classes should register a handler for each event it wants to handle.
open class BaseCoordinator: CoordinatorProtocol {

    private var registeredEvents: [CoordinatorEventType: (CoordinatorEvent) -> Void]

    /// Creates base coordinaator.
    public init() {
        self.registeredEvents = [:]
    }

    /// This method saves saves an association between `CoordinatorEvent` and a handler. Be careful with retention cycles.
    /// - Parameters:
    ///   - eventType: the event type to register.
    ///   - handler: the handler for the event of type `eventType`.
    public func register<Event: CoordinatorEvent>(eventType: Event.Type, handler: @escaping (Event) -> Void) {
        self.registeredEvents[eventType.key] = { event in
            if let event = event as? Event {
                handler(event)
            }
        }
    }

    /// Handler for incoming event. This method checks if the current event corresponds to one of the registered
    /// types and executes the associated handler. If not, it does nothing.
    /// - Parameter event: event to handle.
    open func handle(event: CoordinatorEvent) {
        let key = event.key

        guard let handler = self.registeredEvents[key] else {
            return
        }
        handler(event)
    }

    /// Start the coordinator. By default, it simply executes the `completion`.
    /// - Parameter completion: completion to execute.
    open func start(_ completion: @escaping () -> Void) {
        completion()
    }
}
