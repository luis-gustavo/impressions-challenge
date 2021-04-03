//
//  PhotoSaver.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 03/04/21.
//

import Foundation
import Photos

protocol VideoSaverProtocol {
    func saveVideo(_ url: URL, _ completionHandler: @escaping (Bool, Error?) -> Void)
}

final class VideoSaver: VideoSaverProtocol {
    
    func saveVideo(_ url: URL, _ completionHandler: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: completionHandler)
    }
}
