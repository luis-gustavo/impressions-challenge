//
//  EncondingViewController.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import AVFoundation
import Coordinator
import UIKit

final class EncondingViewController: UIViewController {
    
    // MARK: - Properties
    let videoURL: URL
    let coordinator: CoordinatorProtocol?
    lazy var encodingView: EncodingView = {
        let view = EncodingView()
        return view
    }()
    var videoConverter: VideoConverterProtocol
    let videoSaver: VideoSaverProtocol
    
    // MARK: - LoadView
    override func loadView() {
        self.view = encodingView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        videoConverter.delegate = self
        videoConverter.convertVideo(from: videoURL)
    }
    
    // MARK: - Inits
    init(coordinator: CoordinatorProtocol? = nil,
         videoURL: URL,
         videoConverter: VideoConverterProtocol = VideoConverter(),
         videoSaver: VideoSaverProtocol = VideoSaver()) {
        self.videoURL = videoURL
        self.coordinator = coordinator
        self.videoConverter = videoConverter
        self.videoSaver = videoSaver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: VideoConverterDelegate extension
extension EncondingViewController: VideoConverterDelegate {
    func videoConvertedSuccessfully(_ url: URL) {
        videoSaver.saveVideo(url) { [weak self] (saved, error) in
            DispatchQueue.main.async {
                self?.presentDismissableAlert(title: "Success", message: "The converted video was successfuly saved in your library")
            }
        }
        
    }
    
    func videoConvertedFailure(_ error: VideoConverterError) {
        DispatchQueue.main.async {
            self.presentDismissableAlert(title: "Error", message: error.errorDescription)
        }
    }
    
    func updateProgress(_ progress: Float) {
        encodingView.updateProgress(progress)
    }
}

// MARK: - Private methods extension
private extension EncondingViewController {
    func presentDismissableAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { action in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.coordinator?.handle(event: AppCoordinatorEvent.goToRoot)
                })
            }
        }
        alert.addAction(dismissAction)
        
        self.dismiss(animated: true, completion: {
            self.present(alert, animated: true)
        })
    }
}
