//
//  TestableModels.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import Foundation

// Standalone versions for testing
enum SwipeAction: String, CaseIterable {
    case delete = "削除"
    case hide = "非表示"
    case moveToFolder = "特定のフォルダに移動"
    case favorite = "お気に入り"
    
    var icon: String {
        switch self {
        case .delete:
            return "trash"
        case .hide:
            return "eye.slash"
        case .moveToFolder:
            return "folder"
        case .favorite:
            return "heart"
        }
    }
}

class FolderManager: ObservableObject {
    var customFolders: [String] = []
    var selectedFolder: String = "Sorted"
    
    private let userDefaults = UserDefaults.standard
    private let foldersKey = "CustomFolders"
    
    init() {
        loadCustomFolders()
    }
    
    func loadCustomFolders() {
        if let folders = userDefaults.array(forKey: foldersKey) as? [String] {
            customFolders = folders
        } else {
            // Default folders
            customFolders = ["Sorted", "Favorites", "Archive", "Work", "Personal"]
            saveCustomFolders()
        }
    }
    
    func saveCustomFolders() {
        userDefaults.set(customFolders, forKey: foldersKey)
    }
    
    func addFolder(_ name: String) {
        guard !name.isEmpty && !customFolders.contains(name) else { return }
        customFolders.append(name)
        saveCustomFolders()
    }
    
    func removeFolder(_ name: String) {
        customFolders.removeAll { $0 == name }
        if selectedFolder == name && !customFolders.isEmpty {
            selectedFolder = customFolders.first!
        }
        saveCustomFolders()
    }
}