//
//  Coordinator.swift
//  Coordinator
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import Foundation

/// Defines what a coordinator is
public protocol CoordinatorProtocol: AnyObject {
    func handle(event: CoordinatorEvent)
    func start(_ completion: @escaping () -> Void)
}
