//
//  AppCoordinator.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import AVFoundation
import Coordinator
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    private let window: UIWindow
    private let navigationController = UINavigationController()
    lazy var imagePickerDelegate = ImagePickerDelegate(coordinator: self)
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        super.init()
        self.register(eventType: AppCoordinatorEvent.self) { [unowned self] in self.handle($0) }
    }
    
    override func start(_ completion: @escaping () -> Void) {
        super.start(completion)
        
        let openingViewController = OpeningViewController(coordinator: self)
        navigationController.pushViewController(openingViewController, animated: true)
    }
}

// MARK: - Private methods extension
private extension AppCoordinator {
    
    func handle(_ event: AppCoordinatorEvent) {
        switch event {
        case .goToLibrary: openLibrary()
        case .goToEncoding(let videoURL): openEncoding(with: videoURL)
        case .dismiss: navigationController.dismiss(animated: true)
        case .goToRoot: navigationController.popToRootViewController(animated: true)
        }
    }
    
    func openEncoding(with videoURL: URL) {
        let encondingViewController = EncondingViewController(coordinator: self, videoURL: videoURL)
        navigationController.dismiss(animated: true) { [weak self] in
            self?.navigationController.pushViewController(encondingViewController, animated: true)
        }
    }
    
    func openLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = imagePickerDelegate
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = true
        navigationController.present(picker, animated: true)
    }
}


final class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let coordinator: CoordinatorProtocol?
    
    init(coordinator: CoordinatorProtocol?) {
        self.coordinator = coordinator
        super.init()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        coordinator?.handle(event: AppCoordinatorEvent.dismiss)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let videoUrl = info[.mediaURL] as? URL else { return }
        coordinator?.handle(event: AppCoordinatorEvent.goToEncoding(videoURL: videoUrl))
    }
}
