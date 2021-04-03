//
//  PhotosAuthorization.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 03/04/21.
//

import Photos
import UIKit

struct PhotosAuthorization {
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Properties
    static var isAuthorized: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    static func requestAuthorization(_ completionHandler: ((Bool) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { status in
            let isAuthorized = status == .authorized
            completionHandler?(isAuthorized)
        }
    }
}
