//
//  SwipeToPopApp.swift
//  SwipeToPopApp
//
//  Created on 2024
//

import SwiftUI

@main
struct SwipeToPopApp: App {
    var body: some Scene {
        WindowGroup {
            MainMenuView()
        }
    }
}

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("スワイプ仕分け")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("画像を簡単に整理")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                VStack(spacing: 16) {
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("写真ライブラリから開始")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: DemoView()) {
                        HStack {
                            Image(systemName: "play.circle")
                            Text("デモを試す")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("機能:")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "hand.draw")
                        Text("直感的なスワイプ操作")
                    }
                    
                    HStack {
                        Image(systemName: "gear")
                        Text("カスタマイズ可能なアクション")
                    }
                    
                    HStack {
                        Image(systemName: "folder")
                        Text("フォルダ管理機能")
                    }
                    
                    HStack {
                        Image(systemName: "heart")
                        Text("お気に入り機能")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}