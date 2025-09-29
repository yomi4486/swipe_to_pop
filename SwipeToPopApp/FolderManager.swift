//
//  FolderManager.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import Foundation
import Photos

class FolderManager: ObservableObject {
    @Published var customFolders: [String] = []
    @Published var selectedFolder: String = "Sorted"
    
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
    
    func createPhotoAlbum(named albumName: String, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }) { success, error in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func moveImageToAlbum(asset: PHAsset, albumName: String, completion: @escaping (Bool) -> Void) {
        // First find or create the album
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = collections.firstObject {
            // Album exists, add image to it
            addImageToAlbum(asset: asset, album: album, completion: completion)
        } else {
            // Create album first, then add image
            createPhotoAlbum(named: albumName) { [weak self] success in
                if success {
                    // Fetch the newly created album
                    let newCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                    if let newAlbum = newCollections.firstObject {
                        self?.addImageToAlbum(asset: asset, album: newAlbum, completion: completion)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func addImageToAlbum(asset: PHAsset, album: PHAssetCollection, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) {
                albumChangeRequest.addAssets([asset] as NSArray)
            }
        }) { success, error in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}