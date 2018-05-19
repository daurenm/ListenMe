//
//  FilesManager.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/19/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

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
        
        let fileManager = FileManager.default
        fileManager.changeToPlaylistsDirectory()
//        var path = "\(fileManager.currentDirectoryPath)/\(url.lastPathComponent)"
        var fileURL = URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: fileURL.path) {
            let fileAlreadyExistsResponse = compareTwoFiles(given: fileURL, secondURL: url)
            switch fileAlreadyExistsResponse {
            case .error(let errorText):
                return .error(errorText: errorText)
            case .success(let success):
                if success {
                    return .success(fileURL)
                } else {
                    fileURL = findAppropriateEnding(for: fileURL)
                }
            }
        }
        
        do {
            try fileManager.copyItem(at: url, to: fileURL)
            return .success(fileURL)
        } catch {
            return .error(errorText: error.localizedDescription)
        }
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
        let fileManager = FileManager.default
        let name = url.deletingPathExtension().path
        let `extension` = url.pathExtension
        let newPath = "\(name)-\(currentEnding).\(`extension`)"
        let newURL = URL(fileURLWithPath: newPath)
        if fileManager.fileExists(atPath: newPath) {
            return findAppropriateEnding(for: url, currentEnding: currentEnding + 1)
        }
        return newURL
    }
    
    private func extractNameAndExtension(from path: String) -> (String, String) {
        let url = URL(fileURLWithPath: path)
        let name = url.deletingPathExtension()
        let `extension` = url.pathExtension
        return (name.path, `extension`)
    }
}












