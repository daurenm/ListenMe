//
//  FileManager+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/19/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

extension FileManager {
    
    static let documentsDirectory = `default`.urls(for: .documentDirectory, in: .userDomainMask)[0].path
    static let playlistsDirectory = documentsDirectory + "/Playlists"
    
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
    
    func changeToPlaylistsDirectory() {
        let alreadyExists = fileExists(atPath: FileManager.playlistsDirectory)
        if !alreadyExists {
            do {
                try createDirectory(atPath: FileManager.playlistsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error: \(#function) - \(error.localizedDescription)")
                return
            }
        }
        
        let success = changeCurrentDirectoryPath(FileManager.playlistsDirectory)
        if !success {
            print(#function, "couldn't change directory to playlists :(")
        }
    }
}
