//
//  TabsManager.swift
//  BlinkBarTestApp
//
//  Created by User on 2023-12-02.
//

import Foundation
import SwiftUI
import Combine


final class TabsManager: ObservableObject {
    
    @Published var tabs: [Tab] = [Tab(id: UUID(), name: "blinksh/1")]
    @Published var lastTabId: UUID = UUID()
    @Published var selectedTab: Tab? = nil
    
    func setNewSelected(_ tab: Tab) {
        selectedTab = tab
    }
    
    func setNewSelectedIndex(_ tab: Tab) {
        selectedTab = tab
        lastTabId = tab.id
    }
    
    func setInitialSelectedTab() {
        selectedTab = tabs[0]
    }
    
    func addTab() {
        let newTab = Tab(id: UUID(), name: "blinksh/\(tabs.count + 1)")
        tabs.insert(newTab, at: tabs.firstIndex(of: selectedTab!)! + 1)
        selectedTab = newTab
        lastTabId = newTab.id
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
    }
}
