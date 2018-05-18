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
        let askForPermission = url.startAccessingSecurityScopedResource()
        guard askForPermission else {
            print("Couldn't get permission to view file at '\(url.path)'")
            return false
        }
        
        let fileManager = FileManager.default
        fileManager.changeToDocumentsDirectory()
        var path = "\(fileManager.currentDirectoryPath)/\(url.lastPathComponent)"
        if fileManager.fileExists(atPath: path) {
            guard let fileAlreadyExists = compareTwoFiles(given: path, secondPath: url.path) else { return false }
            if fileAlreadyExists == true {
                preparePlayController(with: path)
                return true
            } else {
                path = findAppropriateEnding(for: path)
            }
        }
        
        do {
            try fileManager.copyItem(atPath: url.path, toPath: path)
            print(fileManager.currentDirectoryFiles!)
        } catch {
            print("Error while copying: \(error.localizedDescription)")
        }
        
        preparePlayController(with: path)
        return true
    }
    
    private func compareTwoFiles(given firstPath: String, secondPath: String) -> Bool? {
        do {
            let firstURL = URL(fileURLWithPath: firstPath)
            let secondURL = URL(fileURLWithPath: secondPath)
            let firstFile = try Data(contentsOf: firstURL)
            let secondFile = try Data(contentsOf: secondURL)
            if firstFile == secondFile {
                print("Hah, the file is already in Documents directory :)")
                return true
            }
            print("Hm, two files different files with the same name :/")
            return false
        } catch {
            print("Got error while comparing two files:", error.localizedDescription)
            return nil
        }
    }
    
    private func findAppropriateEnding(for path: String, currentEnding: Int = 1) -> String {
        let fileManager = FileManager.default
        let newPath = path + "-\(currentEnding)"
        if fileManager.fileExists(atPath: newPath) {
            return findAppropriateEnding(for: path, currentEnding: currentEnding + 1)
        }
        return newPath
    }
    
    private func preparePlayController(with path: String) {
        guard let navController = window?.rootViewController as? UINavigationController,
            let playController = navController.viewControllers.first as? PlayController else { return }
        let url = URL(fileURLWithPath: path)
        playController.prepareToPlayNewFile(url: url)
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

