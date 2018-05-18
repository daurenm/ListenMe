//
//  DirectoriesController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

extension FileManager {
    
    static let documentsDirectory = `default`.urls(for: .documentDirectory, in: .userDomainMask)[0].path
    
    var currentDirectoryFiles: [String]? {
        let items = try? contentsOfDirectory(atPath: currentDirectoryPath)
        return items
    }
    
    func changeToDocumentsDirectory() {
        let success = changeCurrentDirectoryPath(FileManager.documentsDirectory)
        if !success {
            print(#function, "couldn't change directory to documents :(")
        }
    }
}

class DirectoriesController: UIViewController {
    
    // MARK: - Properties
    var fileManager: FileManager { return FileManager.default }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runBasicCommands()
//        fileManager.changeToDocumentsDirectory()
//        print(fileManager.currentDirectoryFiles!)
    }
    
    private func runBasicCommands() {
        // changing current directory to documents directory
        guard fileManager.changeCurrentDirectoryPath(FileManager.documentsDirectory) else {
            assert(false, "Couldn't cd to 'Documents' directory of the app")
        }
        
        // printing current directory files
        print(fileManager.currentDirectoryFiles!)
        
        // creating a file
        let data = Data(capacity: 1024)
        let success = fileManager.createFile(atPath: "dummyFile", contents: data, attributes: nil)
        if success {
            print("Successfully created a file")
        } else {
            print("Failed to create")
        }
        print(fileManager.currentDirectoryFiles!)
        
        // deleting a file
        try? fileManager.removeItem(atPath: "dummyFile")
        print(fileManager.currentDirectoryFiles!)
        
        // creating a directory
        let newDirectoryPath = "dummyFolder/"
        try? fileManager.createDirectory(atPath: newDirectoryPath, withIntermediateDirectories: true, attributes: nil)
        print("Creating a new dir", fileManager.currentDirectoryFiles!)
    
        // removing the created directory
        try? fileManager.removeItem(atPath: newDirectoryPath)
        print("Removing created dir", fileManager.currentDirectoryFiles!)
        
        // creating a directory with intermediate directories
        let directoryPathWithIntermediateOnes = "dummyFolder/one/two/three"
        try? fileManager.createDirectory(atPath: directoryPathWithIntermediateOnes, withIntermediateDirectories: true, attributes: nil)
        print(fileManager.currentDirectoryFiles!)
        
        print(try! fileManager.contentsOfDirectory(atPath: "dummyFolder/one/two"))
        try? fileManager.removeItem(atPath: "dummyFolder")
        print(fileManager.currentDirectoryFiles!)
    }
}











