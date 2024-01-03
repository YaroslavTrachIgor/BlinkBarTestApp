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

    @State var isTabsEditSheetView: Bool = false
    
    //MARK: - Tabs UI Properties
    @State var tabViewSelection: Int = 0
    @State var isTabsBarVisible: Bool = false
    
    //MARK: - Timer Properties
    @State var isShowingRenameAlert = false
    @State var newTabName = ""
    @State var countDownTimer = 7
    @State var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var contextRenameTab: Tab? = nil
    @State var contextRenameTabPlaceholder: String = "Enter new Tab name"
    
    
    
    //MARK: - Main View Configuration
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 300)
                
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
                    countDownTimer = 7
                    print(timerRunning)
                }
            }
        }
    }
    
    
    //MARK: - Main methods
    func restartBarTimer(seconds: Int = 7) {
        countDownTimer = seconds
        timerRunning = true
        isTabsBarVisible = true
    }
}
