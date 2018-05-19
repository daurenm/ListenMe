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
        let fileManager = FileManager.default
        fileManager.changeToPlaylistsDirectory()
    }
    
    // MARK: - Constants
    typealias FilePath = String
    typealias ErrorText = String
    
    enum Response<T> {
        case success(T)
        case error(errorText: ErrorText)
    }
    
    // MARK: - Shared methods
    func tryToSaveFile(given url: URL) -> Response<FilePath> {
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
        var path = "\(fileManager.currentDirectoryPath)/\(url.lastPathComponent)"
        if fileManager.fileExists(atPath: path) {
            let fileAlreadyExistsResponse = compareTwoFiles(given: path, secondPath: url.path)
            switch fileAlreadyExistsResponse {
            case .error(let errorText):
                return .error(errorText: errorText)
            case .success(let success):
                if success {
                    return .success(path)
                } else {
                    path = findAppropriateEnding(for: path)
                }
            }
        }
        
        do {
            try fileManager.copyItem(atPath: url.path, toPath: path)
            return .success(path)
        } catch {
            return .error(errorText: error.localizedDescription)
        }
    }
}

// MARK: - Private methods
extension FilesManager {
    private func compareTwoFiles(given firstPath: String, secondPath: String) -> Response<Bool> {
        do {
            let firstURL = URL(fileURLWithPath: firstPath)
            let secondURL = URL(fileURLWithPath: secondPath)
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
    
    private func findAppropriateEnding(for path: String, currentEnding: Int = 1) -> String {
        let fileManager = FileManager.default
        let (name, `extension`) = extractNameAndExtension(from: path)
        let newPath = "\(name)-\(currentEnding).\(`extension`)"
        if fileManager.fileExists(atPath: newPath) {
            return findAppropriateEnding(for: path, currentEnding: currentEnding + 1)
        }
        return newPath
    }
    
    private func extractNameAndExtension(from path: String) -> (String, String) {
        let url = URL(fileURLWithPath: path)
        let name = url.deletingPathExtension()
        let `extension` = url.pathExtension
        return (name.path, `extension`)
    }
}












