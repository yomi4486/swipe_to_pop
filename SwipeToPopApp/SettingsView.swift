//
//  SettingsView.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: ImageSortingModel
    @Environment(\.dismiss) private var dismiss
    @State private var newFolderName = ""
    @State private var showingAddFolder = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("スワイプ操作設定") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("左スワイプ")
                            .font(.headline)
                        Picker("左スワイプ操作", selection: $model.leftSwipeAction) {
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
                        Picker("右スワイプ操作", selection: $model.rightSwipeAction) {
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
                
                Section("フォルダ設定") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("移動先フォルダ")
                            .font(.headline)
                        Picker("移動先フォルダ", selection: $model.folderManager.selectedFolder) {
                            ForEach(model.folderManager.customFolders, id: \.self) { folder in
                                Text(folder).tag(folder)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Button(action: { showingAddFolder = true }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("新しいフォルダを追加")
                        }
                    }
                    
                    ForEach(model.folderManager.customFolders, id: \.self) { folder in
                        HStack {
                            Text(folder)
                            Spacer()
                            if model.folderManager.customFolders.count > 1 {
                                Button(action: {
                                    model.folderManager.removeFolder(folder)
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                Section("操作説明") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            Text("削除: 写真を完全に削除します")
                        }
                        
                        HStack {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            Text("非表示: 写真を一時的に非表示にします")
                        }
                        
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            Text("フォルダ移動: 指定したフォルダに移動します")
                        }
                        
                        HStack {
                            Image(systemName: "heart")
                                .foregroundColor(.pink)
                                .frame(width: 24)
                            Text("お気に入り: 写真をお気に入りに追加します")
                        }
                    }
                    .font(.caption)
                }
                
                Section("統計") {
                    HStack {
                        Text("総画像数")
                        Spacer()
                        Text("\(model.images.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("現在の位置")
                        Spacer()
                        Text("\(model.currentIndex + 1)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("非表示画像数")
                        Spacer()
                        Text("\(model.images.filter { $0.isHidden }.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("お気に入り数")
                        Spacer()
                        Text("\(model.images.filter { $0.isFavorite }.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("アプリについて") {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Text("スワイプで画像を簡単に仕分けできるアプリです。マッチングアプリのような直感的な操作で、大量の写真を効率的に整理できます。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                }
            }
            .alert("新しいフォルダ", isPresented: $showingAddFolder) {
                TextField("フォルダ名", text: $newFolderName)
                Button("追加") {
                    model.folderManager.addFolder(newFolderName)
                    newFolderName = ""
                }
                Button("キャンセル", role: .cancel) {
                    newFolderName = ""
                }
            } message: {
                Text("新しいフォルダの名前を入力してください")
            }
        }
    }
}

#Preview {
    SettingsView(model: ImageSortingModel())
}