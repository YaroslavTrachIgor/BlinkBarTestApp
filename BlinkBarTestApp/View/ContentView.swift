//
//  ContentView.swift
//  BlinkBarTestApp
//
//  Created by User on 2023-11-25.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject var tabsManager = TabsManager()

    //MARK: - Tabs UI Properties
    @State private var tabViewSelection: Int = 0
    @State private var isTabsBarVisible: Bool = false
    
    //MARK: - Timer Properties
    @State var countDownTimer = 5
    @State var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    //MARK: - Main View Configuration
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isTabsBarVisible.toggle()
                        
                        if isTabsBarVisible {
                            timerRunning = true
                        }
                    }
                }, label: {
                    Text("Show/Hide Tabs")
                        .padding()
                })
                .background(Color.blue)
                .cornerRadius(5)
                .tint(Color.white)
                .padding()
                
                Spacer()
                
                if horizontalSizeClass == .compact {
                    iPhoneTabView
                        .padding(.bottom, isTabsBarVisible ? -25 : -180)
                }
            }
            
            if horizontalSizeClass == .compact {} else {
                VStack {
                    iPadTabsView
                        .padding(.top, isTabsBarVisible ? 16 : -150)
                        .padding(.horizontal, 16)
                    Spacer()
                }
            }
        }
        .onAppear {
            tabsManager.setInitialSelectedTab()
        }
        .onReceive(timer) { _ in
            if countDownTimer > 0 && timerRunning {
                countDownTimer -= 1
                print(countDownTimer)
            } else {
                withAnimation {
                    timerRunning = false
                    isTabsBarVisible = false
                    countDownTimer = 5
                    print(timerRunning)
                }
            }
        }
    }
    
    
    //MARK: - Main methods
    private func restartBarTimer() {
        countDownTimer = 5
        timerRunning = true
    }
}


extension ContentView {
    
    //MARK: - Main iPad Tabs Bar View
    var iPadTabsView: some View {
        VStack {
            HStack(spacing: 20) {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(tabsManager.tabs, id: \.id) { tab in
                                Button(action: {
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
                                                    
                                                    //Button to remove the selected tab
                                                    tabsManager.removeTab(tab)
                                                    restartBarTimer()
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
                                            }
                                        }
                                        .padding(.horizontal, 15)
                                    }
                                    .frame(width: tabsManager.selectedTab == tab ? 280 : 135, height: 35)
                                    .background(tabsManager.selectedTab == tab ? Color(.systemGray2).opacity(0.5) : Color(.systemGray4).opacity(0.415))
                                    .foregroundColor(tabsManager.selectedTab == tab ? Color(.secondaryLabel) : Color(.label).opacity(0.8))
                                    .cornerRadius(17.5)
                                }
                                .onAppear {
                                    withAnimation {
                                        
                                        //Scroll the ScrollView to the tab last appeared on the screen
                                        proxy.scrollTo(tabsManager.lastTabId, anchor: .trailing)
                                    }
                                }
                            }
                        }
                        .cornerRadius(17.5)
                    }
                    .cornerRadius(17.5)
                }
                
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
                
                Button {
                    withAnimation {
                        restartBarTimer()
                    }
                } label: {
                    Text("\(tabsManager.tabs.count) \(tabsManager.tabs.count > 1 ? "Tabs" : "Tab")")
                        .font(.system(size: 15.5))
                        .fontWeight(.medium)
                }
                .padding(.trailing, 12)
                .tint(Color(.label).opacity(0.8))
            }
            .padding(.all, 6)
        }
        .background {
            Color(.systemGray6).opacity(0.8)
                .cornerRadius(29)
        }
    }
    
    
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
                                .padding()
                            
                            Spacer()
                            
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
                                    restartBarTimer()
                                }
                            } label: {
                                Image(systemName: "list.bullet")
                            }
                            .padding(.trailing, 15)
                            .tint(.teal)
                        }
                        .padding(.horizontal, 20)
                        .background(
                            BlurView(style: .systemThinMaterial)
                                .cornerRadius(16)
                                .padding(.horizontal, 20)
                        )
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
