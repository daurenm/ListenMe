//
//  DirectoriesController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

class DirectoriesController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        print("current directory =", fileManager.currentDirectoryPath)
        let dirPaths = fileManager.urls(for: .applicationDirectory, in: .userDomainMask)
        let documentsDirectory = dirPaths[0].path
        print(documentsDirectory)
//        guard fileManager.changeCurrentDirectoryPath(documentsDirectory) else {
//            assert(false, "Couldn't cd to 'Documents' directory of the app")
//        }
//        print(fileManager.currentDirectoryPath)
    }
}
