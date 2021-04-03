//
//  AppDelegate.swift
//  ImpressionsChallenge
//
//  Created by luis.gustavo.jacinto on 02/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Request authorization
        if !PhotosAuthorization.isAuthorized {
            PhotosAuthorization.requestAuthorization()
        }
        
        // Init window
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // Init AppCoordinator
        self.appCoordinator = AppCoordinator(window: window)
        
        // Start app coordinator
        self.appCoordinator?.start { }
        
        return true
    }

}
