//
//  SwipeToPopAppTests.swift
//  SwipeToPopAppTests
//
//  Created on 2024
//

import XCTest
@testable import SwipeToPopApp

final class SwipeToPopAppTests: XCTestCase {
    
    func testSwipeActionEnum() {
        // Test that all swipe actions have proper icons and names
        XCTAssertEqual(SwipeAction.delete.rawValue, "削除")
        XCTAssertEqual(SwipeAction.hide.rawValue, "非表示")
        XCTAssertEqual(SwipeAction.moveToFolder.rawValue, "特定のフォルダに移動")
        XCTAssertEqual(SwipeAction.favorite.rawValue, "お気に入り")
        
        XCTAssertEqual(SwipeAction.delete.icon, "trash")
        XCTAssertEqual(SwipeAction.hide.icon, "eye.slash")
        XCTAssertEqual(SwipeAction.moveToFolder.icon, "folder")
        XCTAssertEqual(SwipeAction.favorite.icon, "heart")
    }
    
    func testFolderManagerBasicFunctionality() {
        let folderManager = FolderManager()
        
        // Test adding folders
        let initialCount = folderManager.customFolders.count
        folderManager.addFolder("Test Folder")
        XCTAssertEqual(folderManager.customFolders.count, initialCount + 1)
        XCTAssertTrue(folderManager.customFolders.contains("Test Folder"))
        
        // Test removing folders
        folderManager.removeFolder("Test Folder")
        XCTAssertFalse(folderManager.customFolders.contains("Test Folder"))
        
        // Test not adding duplicate folders
        folderManager.addFolder("Duplicate")
        folderManager.addFolder("Duplicate")
        let duplicateCount = folderManager.customFolders.filter { $0 == "Duplicate" }.count
        XCTAssertEqual(duplicateCount, 1)
    }
    
    func testSwipeActionCaseIterable() {
        // Test that all cases are accessible
        let allCases = SwipeAction.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.delete))
        XCTAssertTrue(allCases.contains(.hide))
        XCTAssertTrue(allCases.contains(.moveToFolder))
        XCTAssertTrue(allCases.contains(.favorite))
    }
}