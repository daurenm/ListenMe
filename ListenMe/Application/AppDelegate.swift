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
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppCoordinator()
        return true
    }
    
    private func setupAppCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AVAudioSession.deactivateIfNeeded()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        appCoordinator.openNewTrack(with: url)
        return true
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

