//
//  iPhoneTabView.swift
//  BlinkBarTestApp
//
//  Created by User on 2024-01-03.
//

import Foundation
import SwiftUI
import Combine

extension ContentView {
    
    //MARK: - Main iPhone Tabs Bar View
    var iPhoneTabView: some View {
        VStack {
            TabView(selection: $tabViewSelection) {
                ForEach(tabsManager.tabs.indices, id: \.self) { index in
                    VStack {
                        Spacer()
                        
                        HStack {
                            Text(tabsManager.tabs[index].name)
                                .font(.system(size: 17, weight: .regular))
                                .frame(width: 200, alignment: .leading)
                                .padding()
                            
                            Spacer()
                                .frame(maxWidth: .infinity)
                            
                            Button {
                                withAnimation {
                                    
                                    //Button to create a new Tab
                                    tabsManager.addTab()
                                    restartBarTimer()
                                }
                                
                            } label: {
                                Image(systemName: "plus")
                            }
                            .padding(.horizontal, 5)
                            .tint(.teal)
                            
                            Button {
                                withAnimation {
                                    isTabsEditSheetView.toggle()
                                    restartBarTimer(seconds: 999)
                                }
                            } label: {
                                Image(systemName: "list.bullet")
                            }
                            .padding(.trailing, 15)
                            .tint(.teal)
                        }
                        .cornerRadius(16)
                        .background(
                            BlurView(style: .systemThinMaterial)
                                .cornerRadius(16)
                        )
                        .contextMenu {
                            VStack {
                                Button(action: {
                                    restartBarTimer(seconds: 999)
                                    isShowingRenameAlert.toggle()
                                }) {
                                    Label("Rename", systemImage: "pencil")
                                }
                                if tabsManager.tabs.count != 1 {
                                    Button(role: .destructive, action: {
                                        withAnimation {
                                            restartBarTimer()
                                            tabsManager.removeTab(tabsManager.tabs[index])
                                        }
                                    }) {
                                        Label("Delete ", systemImage: "multiply")
                                    }
                                    .tint(.red)
                                }
                            }
                            .onAppear {
                                restartBarTimer(seconds: 999)
                            }
                        }
                        .alert("New Tab Name", isPresented: $isShowingRenameAlert) {
                            TextField(tabsManager.tabs[index].name, text: $newTabName)
                                    .textInputAutocapitalization(.never)
                            Button("OK", action: {
                                withAnimation {
                                    tabsManager.renameTab(tabsManager.tabs[index], newName: newTabName)
                                    restartBarTimer(seconds: 7)
                                    newTabName = ""
                                    tabsManager.setNewSelected(tabsManager.tabs[index])
                                }
                            })
                            Button("Cancel", role: .cancel) {
                                newTabName = "";
                                restartBarTimer(seconds: 7);
                                tabsManager.setNewSelected(tabsManager.tabs[index]) }
                            } message: {
                                Text("Please enter new tab name.")
                            }
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .tag(index)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                        .onAppear {
                            withAnimation {
                                
                                //Set a new selected tab when the user creates a new tab
                                if index == tabViewSelection {
                                    tabsManager.setNewSelected(tabsManager.tabs[index])
                                }
                            }
                        }
                        .padding(.horizontal, 0)
                        .safeAreaPadding(.horizontal, 0)
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 0)
                    .safeAreaPadding(.horizontal, 0)
                }
            }
            .fullScreenCover(isPresented: $isTabsEditSheetView) {
                TabsEditSheetView(tabsManager: tabsManager)
            }
            .onChange(of: tabViewSelection) { newIndex in
                withAnimation {
                    
                    //Set a new selected tab when the user scrolls bar
                    tabsManager.setNewSelectedIndex(tabsManager.tabs[newIndex])
                    restartBarTimer()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                withAnimation {
                    
                    //Set the first tab selected when the app launches
                    if let tab = tabsManager.tabs.first {
                        tabsManager.setNewSelected(tab)
                    }
                }
            }
            .onReceive(Just(tabsManager.tabs.count)) { _ in
                
                //Scroll the Bar to a newly created Tab
                if let index = tabsManager.tabs.firstIndex(of: tabsManager.selectedTab!) {
                    withAnimation {
                        tabViewSelection = index
                    }
                }
            }
        }
    }
}
