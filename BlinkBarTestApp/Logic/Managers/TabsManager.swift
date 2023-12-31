//
//  TabsManager.swift
//  BlinkBarTestApp
//
//  Created by User on 2023-12-02.
//

import Foundation
import SwiftUI
import Combine

extension Notification.Name {
    static let tabsUpdated = Notification.Name("tabsUpdated")
}

final class TabsManager: ObservableObject {
    
    @Published var tabs: [Tab] = [Tab(id: UUID(), name: "blinksh/1")]
    @Published var lastTabId: UUID = UUID()
    @Published var selectedTab: Tab? = nil
    @Published var draggedTab: Tab? = nil
    
    func setNewSelected(_ tab: Tab) {
        selectedTab = tab
        updateTabs()
    }
    
    func setNewSelectedIndex(_ tab: Tab) {
        selectedTab = tab
        lastTabId = tab.id
        updateTabs()
    }
    
    func setInitialSelectedTab() {
        selectedTab = tabs[0]
        updateTabs()
    }
    
    func addTab() {
        let newTab = Tab(id: UUID(), name: "blinksh/\(tabs.count + 1)")
        print(tabs.firstIndex(of: selectedTab!) ?? "No ID")
        tabs.insert(newTab, at: tabs.firstIndex(of: selectedTab!)! + 1)
        selectedTab = newTab
        lastTabId = newTab.id
        updateTabs()
    }
    
    func renameTab(_ tab: Tab, newName: String) {
        if let index = tabs.firstIndex(of: tab) {
            tabs[index].name = newName
            selectedTab = tabs[index]
            lastTabId = tabs[index].id
        }
        updateTabs()
    }
    
    func removeTab(_ tab: Tab) {
        if (tabs.count > 1 && tabs[0] != tab) || (tabs.count > 1 && tab == tabs[0]) {
            if let index = tabs.firstIndex(of: tab) {
                if selectedTab == tab {
                    if tabs.count != 1 {
                        if tabs.count > 1 && tab == tabs[0] {
                            selectedTab = tabs[index + 1]
                            lastTabId = tabs[index + 1].id
                        } else {
                            selectedTab = tabs[index - 1]
                            lastTabId = tabs[index - 1].id
                        }
                    }
                }
                tabs.remove(at: index)
            }
        }
        updateTabs()
    }
    
    func removeTabs(at indexes: [Int]) {
        let sortedIndexes = indexes.sorted(by: >)
        for index in sortedIndexes {
            tabs.remove(at: index)
        }
        updateTabs()
    }
    
    func updateTabs() {
        NotificationCenter.default.post(name: .tabsUpdated, object: nil)
    }
}
