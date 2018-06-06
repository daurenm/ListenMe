//
//  FilesManager.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/19/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation
import AVFoundation

class FilesManager {
    
    // MARK: - Singleton
    static let `default` = FilesManager()
    private init() {
        // create necessary directories
        FileManager.default.changeToPlaylistsDirectory()
    }
    
    // MARK: - Constants
    typealias FilePath = String
    typealias ErrorText = String
    typealias Directory = URL
    
    var fileManager: FileManager {
        return FileManager.default
    }
    
    enum Response<T> {
        case success(T)
        case error(errorText: ErrorText)
    }
    
    // MARK: - Shared methods
    func tryToSaveFile(given url: URL) -> Response<URL> {
        let fromAnotherApp = !url.path.contains("Inbox")
        if fromAnotherApp {
            let askForPermission = url.startAccessingSecurityScopedResource()
            guard askForPermission else {
                print("Couldn't get permission to view file at '\(url.path)'")
                return .error(errorText: "Couldn't get permission to view the file :(")
            }
        }
        
        var response: Response<URL>? = nil
        
        let fileManager = FileManager.default
        fileManager.changeToPlaylistsDirectory()
        var fileURL = URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: fileURL.path) {
            let fileAlreadyExistsResponse = compareTwoFiles(given: fileURL, secondURL: url)
            switch fileAlreadyExistsResponse {
            case .error(let errorText):
                response = .error(errorText: errorText)
            case .success(let success):
                if success {
                    response = .success(fileURL)
                } else {
                    fileURL = findAppropriateEnding(for: fileURL)
                }
            }
        }
        
        if response == nil {
            do {
                try fileManager.copyItem(at: url, to: fileURL)
                response = .success(fileURL)
            } catch {
                response = .error(errorText: error.localizedDescription)
            }
        }
        
        removeFile(at: url)
        return response!
    }
    
    func getListOfFilesWithDuration(in directory: Directory = FileManager.playlistsURL) -> Response<[Track]> {
        let success = fileManager.changeCurrentDirectoryPath(directory.path)
        guard success else {
            return .error(errorText: "Couldn't change current directory to \(directory.path) :/")
        }
        guard let list = fileManager.currentDirectoryFiles else {
            return .error(errorText: "Couldn't get dir:\(directory.path) files :/")
        }
        
        let response: [Track] = list.map { (url) -> Track in
            let asset = AVURLAsset(url: url)
            let duration = asset.duration
            let durationInSeconds = Int(CMTimeGetSeconds(duration))
            return Track(url: url, durationInSeconds: durationInSeconds)
        }
        return .success(response)
    }
}

// MARK: - Private methods
extension FilesManager {
    private func compareTwoFiles(given firstURL: URL, secondURL: URL) -> Response<Bool> {
        do {
            let firstFile = try Data(contentsOf: firstURL)
            let secondFile = try Data(contentsOf: secondURL)
            if firstFile == secondFile {
                print("Hah, the file is already in Documents directory :)")
                return .success(true)
            }
            print("Hm, two different files with the same name :/")
            return .success(false)
        } catch {
            print("Got error while comparing two files:", error.localizedDescription)
            return .error(errorText: "Error: \(error.localizedDescription)")
        }
    }
    
    private func findAppropriateEnding(for url: URL, currentEnding: Int = 1) -> URL {
        let name = url.deletingPathExtension().path
        let `extension` = url.pathExtension
        let newPath = "\(name)-\(currentEnding).\(`extension`)"
        if fileManager.fileExists(atPath: newPath) {
            return findAppropriateEnding(for: url, currentEnding: currentEnding + 1)
        }
        let newURL = URL(fileURLWithPath: newPath)
        return newURL
    }
    
    private func extractNameAndExtension(from path: String) -> (String, String) {
        let url = URL(fileURLWithPath: path)
        let name = url.deletingPathExtension()
        let `extension` = url.pathExtension
        return (name.path, `extension`)
    }
    
    private func removeFile(at url: URL) {
        guard url.path.contains("Inbox") else { return }
        
        guard fileManager.fileExists(atPath: url.path) else {
            print("\(url.path) doesn't exist")
            return
        }
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(#function, error.localizedDescription)
        }
    }
}












