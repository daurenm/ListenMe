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
//        let rootViewController = PlayLocalAudioFile()
        let rootViewController = DirectoriesController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AVAudioSession.deactivateIfNeeded()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let askForPermission = url.startAccessingSecurityScopedResource()
        guard askForPermission else {
            print("Couldn't get permission to view file at '\(url.path)'") // replace with alert
            return false
        }
        
        let fileManager = FileManager.default
        let newPath = "\(fileManager.currentDirectoryPath)/\(url.lastPathComponent)"
        do {
            try fileManager.copyItem(atPath: url.path, toPath: newPath)
            print(fileManager.currentDirectoryFiles!)
        } catch {
            print("Error while copying: \(error.localizedDescription)") // replace with alert
        }

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

