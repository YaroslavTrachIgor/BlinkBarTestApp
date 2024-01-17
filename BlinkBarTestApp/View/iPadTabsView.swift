//
//  iPadTabsView.swift
//  BlinkBarTestApp
//
//  Created by User on 2024-01-03.
//

import Foundation
import SwiftUI

extension ContentView {
    
    //MARK: - Main iPad Tabs Bar View
    var iPadTabsView: some View {
        VStack {
            HStack(spacing: 20) {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            LazyHGrid(rows: columns) {
                                ForEach(tabsManager.tabs, id: \.self) { tab in
                                    tabButtonView(tab: tab, proxy: proxy)
                                        .id(tab.id)
                                }
                            }
                            .cornerRadius(17.5)
                        }
                        .cornerRadius(17.5)
                    }
                    .cornerRadius(17.5)
                }
                
                addTabButton
                tabsCountButton
            }
            .padding(.all, 6)
            .frame(height: 48)
            .background(Color.clear.cornerRadius(29).frame(height: 45))
        }
        .background {
            Color(.systemGray6).opacity(0.8)
                .cornerRadius(29)
        }
    }
    
    
    //MARK: - Single Tab View
    func tabButtonView(tab: Tab, proxy: ScrollViewProxy) -> some View {
        return Button(action: {
            withAnimation {
                
                //Set new selected tab when the user taps on the other tab
                tabsManager.setNewSelected(tab)
                restartBarTimer()
            }
        }) {
            HStack {
                HStack {
                    if tabsManager.selectedTab == tab && tabsManager.tabs.count > 1 {
                        Button(action: {
                            withAnimation {
                                
                                //Button to remove the selected tab
                                tabsManager.removeTab(tab)
                                restartBarTimer()
                            }
                        }) {
                            ZStack {
                                Color(.secondaryLabel)
                                    .cornerRadius(3.0)
                                Image(systemName: "multiply")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.systemGray4))
                                    .font(.system(size: 11))
                            }
                            .frame(width: 15, height: 15)
                            .padding(.leading, 0)
                            .padding(.trailing, 4)
                            .onAppear {
                                withAnimation {
                        
                                    //Scroll the ScrollView to the tab last appeared on the screen
                                    proxy.scrollTo(tabsManager.lastTabId, anchor: .trailing)
                                }
                            }
                        }
                    } else {
                        if tabsManager.tabs.count > 1 {
                            Image(systemName: "slash.circle.fill")
                                .fontWeight(.medium)
                                .padding(.leading, 0)
                        }
                    }
                    Text(tab.name)
                        .font(.system(size: 15.5))
                        .fontWeight(.medium)
                    
                    if tabsManager.selectedTab == tab {
                        Spacer()
                        Image(systemName: "slash.circle.fill")
                            .fontWeight(.medium)
                            .opacity(0.6)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.leading, 0)
                            .onAppear {
                                withAnimation {
                        
                                    //Scroll the ScrollView to the tab last appeared on the screen
                                    proxy.scrollTo(tabsManager.lastTabId, anchor: .trailing)
                                }
                            }
                    }
                }
                .padding(.horizontal, 15)
            }
            .cornerRadius(17.5)
            .frame(width: tabsManager.selectedTab == tab ? 280 : 135, height: 35)
            .background(determineBackgroundColor(for: tab))
            .foregroundColor(tabsManager.selectedTab == tab ? Color(.secondaryLabel) : Color(.label).opacity(0.8))
            .cornerRadius(17.5)
            .contextMenu {
                if tabsManager.selectedTab == tab {
                    tabContextMenuView(for: tab)
                }
            }
            .alert("Rename Tab", isPresented: $isShowingRenameAlert) {
                renameAlertView
            } message: {
                Text("Enter new tab name")
            }
        }
        .cornerRadius(17.5)
        .overlay(dragging?.id == tab.id ? Color.white.opacity(0.4).cornerRadius(17.5) : Color.clear.cornerRadius(17.5))
        .onDrag {
            withAnimation {
                self.dragging = tab
                restartBarTimer(seconds: 999)
            }
            return NSItemProvider(object: String(tab.id.description) as NSString)
        }
        .onDrop(of: ["public.utf8-plain-text"], delegate: DragRelocateDelegate(item: tab, listData: $tabsManager.tabs, current: $dragging))
        .cornerRadius(17.5)
    }
    
    
    //MARK: - Main Context View
    func tabContextMenuView(for tab: Tab) -> some View {
        VStack {
            Button(action: {
                isShowingRenameAlert.toggle()
                restartBarTimer(seconds: 999)
            }) {
                Label("Rename", systemImage: "pencil")
            }
            
            if tabsManager.tabs.count != 1 {
                Button(role: .destructive, action: {
                    withAnimation {
                        tabsManager.removeTab(tab)
                        restartBarTimer()
                    }
                }) {
                    Label("Delete ", systemImage: "multiply")
                }
                .tint(.red)
            }
        }
        .onAppear {
            print("Tab Name")
            print(tab.name)
            contextRenameTab = tab
            contextRenameTabPlaceholder = tab.name
            restartBarTimer(seconds: 999)
        }
    }
    
    
    //MARK: - Rename Alert View
    var renameAlertView: some View {
        VStack {
            TextField(contextRenameTabPlaceholder, text: $newTabName)
                .textInputAutocapitalization(.never)
            Button("OK") {
                withAnimation {
                    if let contextTab = contextRenameTab {
                        tabsManager.renameTab(contextTab, newName: newTabName)
                        newTabName = ""
                        restartBarTimer()
                    }
                }
            }
            Button("Cancel", role: .cancel) { newTabName = ""; restartBarTimer() }
        }
    }
    
    
    //MARK: - Add Tab Button View
    var addTabButton: some View {
        Button {
            withAnimation {
                
                //Button to create a new Tab
                tabsManager.addTab()
                restartBarTimer()
            }
        } label: {
            VStack {
                HStack {
                    Image(systemName: "plus")
                    Text("New Tab")
                        .font(.system(size: 15.5))
                        .fontWeight(.medium)
                }
            }
        }
        .padding(.horizontal, 5)
        .frame(width: 115, height: 35)
        .background(Color(.systemGray4).opacity(0.415))
        .tint(Color(.label).opacity(0.8))
        .cornerRadius(17.5)
    }
    
    
    //MARK: - Tabs Count Button View
    var tabsCountButton: some View {
        Button {
            withAnimation {
                restartBarTimer(seconds: 7)
            }
        } label: {
            Text("\(tabsManager.tabs.count) \(tabsManager.tabs.count > 1 ? "Tabs" : "Tab")")
                .font(.system(size: 15.5))
                .fontWeight(.medium)
        }
        .padding(.trailing, 12)
        .tint(Color(.label).opacity(0.8))
    }
    
    private func determineBackgroundColor(for tab: Tab) -> Color {
        return tabsManager.selectedTab == tab ? Color(.systemGray2).opacity(0.5) : Color(.systemGray4).opacity(0.415)
    }
}




struct MyDropDelegate: DropDelegate {
    var onEnter: (DropInfo)->Void
    var onExit: (DropInfo)->Void
    var onDrop: (DropInfo)->Void
    
    func dropEntered(info: DropInfo) {
        onEnter(info)
    }
    
    func dropExited(info: DropInfo) {
        onExit(info)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        onDrop(info)
        return true
    }
}


struct DragRelocateDelegate: DropDelegate {
    let item: Tab
    @Binding var listData: [Tab]
    @Binding var current: Tab?

    func dropEntered(info: DropInfo) {
        withAnimation {
            if item != current {
                let from = listData.firstIndex(of: current!)!
                let to = listData.firstIndex(of: item)!
                if listData[to].id != current!.id {
                    listData.move(fromOffsets: IndexSet(integer: from),
                        toOffset: to > from ? to + 1 : to)
                }
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            self.current = nil
        }
        return true
    }
}
