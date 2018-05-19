//
//  AppDelegate.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/12/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
//        let rootViewController = PlaylistController()
        let rootViewController = PlayController()
//        let rootViewController = DirectoriesController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AVAudioSession.deactivateIfNeeded()
    }
    
    // NOTE: later, replace prints with alerts

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // save given file
        let saveFileResponse = FilesManager.default.tryToSaveFile(given: url)
        switch saveFileResponse {
        case .error(let errorText):
            showAlert(.error(errorText))
        case .success(let fileURL):
            preparePlayController(with: fileURL)
        }
        return true
    }
    
    enum Alert {
        case error(String)
        case alert(String)
    }
    
    private func showAlert(_ alert: Alert) {
        let title: String
        let message: String
        switch alert {
        case .alert(let text):
            title = "Alert"
            message = text
        case .error(let text):
            title = "Error"
            message = text
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        guard let navController = window?.rootViewController as? UINavigationController else { return }
        navController.present(alertController, animated: true)
    }
    
    private func preparePlayController(with fileURL: URL) {
        guard let navController = window?.rootViewController as? UINavigationController,
            let playController = navController.viewControllers.first as? PlayController else { return }
        playController.prepareToPlayNewFile(url: fileURL)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    
}

