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
    lazy var appCoordinator: AppCoordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupStyling()
        setupWindow()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AVAudioSession.deactivateIfNeeded()
        
        appCoordinator.updateNowPlayingInfoCenter()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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

extension AppDelegate {
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.toPresent()
        window?.makeKeyAndVisible()
        appCoordinator.start()
    }
    
    private func setupStyling() {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.isTranslucent = false
        barAppearance.barTintColor = .navigationBarBackground
        barAppearance.tintColor = .navigationBarTint
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.navigationBarTint]
    }
}













