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

}

class DirectoriesController: UIViewController {
    
    // MARK: - Properties
    var fileManager: FileManager { return FileManager.default }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // changing current directory to documents directory
        guard fileManager.changeCurrentDirectoryPath(FileManager.documentsDirectory) else {
            assert(false, "Couldn't cd to 'Documents' directory of the app")
        }
        
        // printing current directory files
        let items = try? fileManager.contentsOfDirectory(atPath: fileManager.currentDirectoryPath)
        print(items!)

        // creating a file
        let data = Data(capacity: 1024)
        let success = fileManager.createFile(atPath: "dummyFile", contents: data, attributes: nil)
        if success {
            print("Successfully created a file")
        } else {
            print("Failed to create")
        }
        
        let newItems = try? fileManager.contentsOfDirectory(atPath: fileManager.currentDirectoryPath)
        print(newItems!)
    }
}
