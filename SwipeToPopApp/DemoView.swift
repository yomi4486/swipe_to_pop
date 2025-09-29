//
//  DemoView.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import SwiftUI

struct DemoView: View {
    @State private var currentImageIndex = 0
    @State private var dragOffset = CGSize.zero
    @State private var dragRotation = 0.0
    @State private var leftSwipeAction: SwipeAction = .delete
    @State private var rightSwipeAction: SwipeAction = .favorite
    @State private var showingSettings = false
    
    let demoImages = ["photo1", "photo2", "photo3", "photo4", "photo5"]
    let demoColors: [Color] = [.red, .blue, .green, .orange, .purple]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("スワイプで仕分け (デモ)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("\(currentImageIndex + 1) / \(demoImages.count)")
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
                    
                    // Demo image display
                    if currentImageIndex < demoImages.count {
                        DemoImageCardView(
                            imageName: demoImages[currentImageIndex],
                            color: demoColors[currentImageIndex % demoColors.count]
                        )
                        .offset(dragOffset)
                        .rotationEffect(.degrees(dragRotation))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                    dragRotation = Double(value.translation.x / 20)
                                }
                                .onEnded { value in
                                    handleSwipe(value: value)
                                }
                        )
                        .animation(.spring(), value: dragOffset)
                    } else {
                        VStack {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            Text("デモ完了！")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding()
                            Button("リセット") {
                                currentImageIndex = 0
                            }
                            .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    // Action indicators
                    HStack {
                        VStack {
                            Image(systemName: leftSwipeAction.icon)
                                .font(.title)
                                .foregroundColor(.red)
                            Text(leftSwipeAction.rawValue)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .opacity(dragOffset.x < -50 ? 1.0 : 0.3)
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: rightSwipeAction.icon)
                                .font(.title)
                                .foregroundColor(.green)
                            Text(rightSwipeAction.rawValue)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .opacity(dragOffset.x > 50 ? 1.0 : 0.3)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingSettings) {
                DemoSettingsView(
                    leftSwipeAction: $leftSwipeAction,
                    rightSwipeAction: $rightSwipeAction
                )
            }
        }
    }
    
    private func handleSwipe(value: DragGesture.Value) {
        let threshold: CGFloat = 100
        
        if value.translation.x > threshold {
            // Right swipe
            performAction(rightSwipeAction)
        } else if value.translation.x < -threshold {
            // Left swipe
            performAction(leftSwipeAction)
        }
        
        // Reset position
        dragOffset = .zero
        dragRotation = 0.0
    }
    
    private func performAction(_ action: SwipeAction) {
        // Simulate action with animation
        withAnimation {
            if currentImageIndex < demoImages.count - 1 {
                currentImageIndex += 1
            } else {
                currentImageIndex = demoImages.count // Show completion
            }
        }
    }
}

struct DemoImageCardView: View {
    let imageName: String
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [color.opacity(0.8), color.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(maxWidth: .infinity, maxHeight: 500)
            .cornerRadius(12)
            .shadow(radius: 10)
            .overlay(
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                    Text("デモ画像 \(imageName)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            )
    }
}

struct DemoSettingsView: View {
    @Binding var leftSwipeAction: SwipeAction
    @Binding var rightSwipeAction: SwipeAction
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("スワイプ操作設定 (デモ)") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("左スワイプ")
                            .font(.headline)
                        Picker("左スワイプ操作", selection: $leftSwipeAction) {
                            ForEach(SwipeAction.allCases, id: \.self) { action in
                                HStack {
                                    Image(systemName: action.icon)
                                    Text(action.rawValue)
                                }
                                .tag(action)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("右スワイプ")
                            .font(.headline)
                        Picker("右スワイプ操作", selection: $rightSwipeAction) {
                            ForEach(SwipeAction.allCases, id: \.self) { action in
                                HStack {
                                    Image(systemName: action.icon)
                                    Text(action.rawValue)
                                }
                                .tag(action)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section("デモについて") {
                    Text("これは写真ライブラリにアクセスしないデモ版です。実際のアプリでは本物の写真を読み込んで操作できます。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("設定 (デモ)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DemoView()
}