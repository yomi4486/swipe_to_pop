//
//  ImageSortingModel.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import Foundation
import Photos
import SwiftUI

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

struct ImageItem: Identifiable {
    let id = UUID()
    let asset: PHAsset
    var isHidden: Bool = false
    var isFavorite: Bool = false
    var folderPath: String?
}

class ImageSortingModel: ObservableObject {
    @Published var images: [ImageItem] = []
    @Published var currentIndex: Int = 0
    @Published var leftSwipeAction: SwipeAction = .delete
    @Published var rightSwipeAction: SwipeAction = .favorite
    @Published var folderManager = FolderManager()
    
    private let imageManager = PHImageManager.default()
    
    init() {
        requestPhotoLibraryAccess()
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self?.loadImages()
                }
            }
        }
    }
    
    func loadImages() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var imageItems: [ImageItem] = []
        fetchResult.enumerateObjects { asset, _, _ in
            imageItems.append(ImageItem(asset: asset))
        }
        
        self.images = imageItems
    }
    
    func performSwipeAction(_ action: SwipeAction, on imageItem: ImageItem) {
        guard let index = images.firstIndex(where: { $0.id == imageItem.id }) else { return }
        
        switch action {
        case .delete:
            deleteImage(at: index)
        case .hide:
            hideImage(at: index)
        case .moveToFolder:
            moveImageToFolder(at: index)
        case .favorite:
            favoriteImage(at: index)
        }
    }
    
    private func deleteImage(at index: Int) {
        let asset = images[index].asset
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.images.remove(at: index)
                    self?.moveToNextImage()
                }
            }
        }
    }
    
    private func hideImage(at index: Int) {
        images[index].isHidden = true
        moveToNextImage()
    }
    
    private func moveImageToFolder(at index: Int) {
        let asset = images[index].asset
        let selectedFolder = folderManager.selectedFolder
        
        folderManager.moveImageToAlbum(asset: asset, albumName: selectedFolder) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.images[index].folderPath = selectedFolder
                    self?.moveToNextImage()
                }
            }
        }
    }
    
    private func favoriteImage(at index: Int) {
        let asset = images[index].asset
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: asset)
            request.isFavorite = true
        }) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.images[index].isFavorite = true
                    self?.moveToNextImage()
                }
            }
        }
    }
    
    private func moveToNextImage() {
        if currentIndex < images.count - 1 {
            currentIndex += 1
        }
    }
    
    func getCurrentImage() -> ImageItem? {
        guard currentIndex < images.count else { return nil }
        return images[currentIndex]
    }
    
    func getVisibleImages() -> [ImageItem] {
        return images.filter { !$0.isHidden }
    }
}