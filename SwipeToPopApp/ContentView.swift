//
//  ContentView.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import SwiftUI
import Photos

struct ContentView: View {
    @StateObject private var model = ImageSortingModel()
    @State private var showingSettings = false
    @State private var dragOffset = CGSize.zero
    @State private var dragRotation = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("スワイプで仕分け")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("\(model.currentIndex + 1) / \(model.images.count)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingSettings = true }) {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .padding()
                    
                    // Main image display
                    if let currentImage = model.getCurrentImage() {
                        ImageCardView(imageItem: currentImage)
                            .offset(dragOffset)
                            .rotationEffect(.degrees(dragRotation))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                        dragRotation = Double(value.translation.x / 20)
                                    }
                                    .onEnded { value in
                                        handleSwipe(value: value, imageItem: currentImage)
                                    }
                            )
                            .animation(.spring(), value: dragOffset)
                    } else {
                        VStack {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("画像がありません")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    // Action indicators
                    HStack {
                        VStack {
                            Image(systemName: model.leftSwipeAction.icon)
                                .font(.title)
                                .foregroundColor(.red)
                            Text(model.leftSwipeAction.rawValue)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .opacity(dragOffset.x < -50 ? 1.0 : 0.3)
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: model.rightSwipeAction.icon)
                                .font(.title)
                                .foregroundColor(.green)
                            Text(model.rightSwipeAction.rawValue)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .opacity(dragOffset.x > 50 ? 1.0 : 0.3)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(model: model)
            }
        }
    }
    
    private func handleSwipe(value: DragGesture.Value, imageItem: ImageItem) {
        let threshold: CGFloat = 100
        
        if value.translation.x > threshold {
            // Right swipe
            model.performSwipeAction(model.rightSwipeAction, on: imageItem)
        } else if value.translation.x < -threshold {
            // Left swipe
            model.performSwipeAction(model.leftSwipeAction, on: imageItem)
        }
        
        // Reset position
        dragOffset = .zero
        dragRotation = 0.0
    }
}

struct ImageCardView: View {
    let imageItem: ImageItem
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 500)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: 500)
                    .cornerRadius(12)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    )
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        manager.requestImage(
            for: imageItem.asset,
            targetSize: CGSize(width: 800, height: 800),
            contentMode: .aspectFit,
            options: options
        ) { image, _ in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

#Preview {
    ContentView()
}