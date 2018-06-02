//
//  FileManager+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/19/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

extension FileManager {
    
    static let documentsURL = URL(fileURLWithPath: `default`.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
    static let playlistsURL = documentsURL.appendingPathComponent("Playlists", isDirectory: true)
    
    var currentDirectoryFiles: [String]? {
        let items = try? contentsOfDirectory(atPath: currentDirectoryPath)
        return items
    }
    
    func changeToDocumentsDirectory() {
        let success = changeCurrentDirectoryPath(FileManager.documentsURL.path)
        if !success {
            print(#function, "couldn't change directory to documents :(")
        }
    }
    
    func changeToPlaylistsDirectory() {
        let alreadyExists = fileExists(atPath: FileManager.playlistsURL.path)
        if !alreadyExists {
            do {
                try createDirectory(at: FileManager.playlistsURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error: \(#function) - \(error.localizedDescription)")
                return
            }
        }
        
        let success = changeCurrentDirectoryPath(FileManager.playlistsURL.path)
        if !success {
            print(#function, "couldn't change directory to playlists :(")
        }
    }
}
