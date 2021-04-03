//
//  AppCoordinatorEvent.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import Coordinator

enum AppCoordinatorEvent: CoordinatorEvent {
    case goToLibrary
    case goToEncoding(videoURL: URL)
    case dismiss
    case goToRoot
}
