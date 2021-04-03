//
//  OpeningViewController.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import AVFoundation
import Coordinator
import UIKit

final class OpeningViewController: UIViewController {
    
    // MARK: - Properties
    let coordinator: CoordinatorProtocol?
    lazy var openingView: OpeningView = {
        let view = OpeningView()
        view.delegate = self
        return view
    }()

    // MARK: - LoadView
    override func loadView() {
        self.view = openingView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Inits
    init(coordinator: CoordinatorProtocol? = nil) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - OpeningViewDelegate extension
extension OpeningViewController: OpeningViewDelegate {
    func browseVideosTouched() {
        if PhotosAuthorization.isAuthorized {
            coordinator?.handle(event: AppCoordinatorEvent.goToLibrary)
        } else {
            PhotosAuthorization.requestAuthorization()
        }
    }
}
