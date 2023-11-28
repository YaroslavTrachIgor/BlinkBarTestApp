//
//  ContentView.swift
//  BlinkBarTestApp
//
//  Created by User on 2023-11-25.
//

import SwiftUI


struct Tab: Identifiable, Equatable, Hashable {
    var id: UUID
    var name: String
}


struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    
    @State private var tabs: [Tab] = []
    @State private var selectedTab: Tab? = nil
    
    var body: some View {
        ZStack {
            VStack {
                if horizontalSizeClass == .compact {
                    
                } else {
                    iPadTabsView
                }
                
                Spacer()
                Button("Add Tab") {
                    addTab()
                }
                .padding()
                Spacer()
            }
            .padding()
            
            if horizontalSizeClass == .compact {
                iPhoneTabView
            }
        }
    }
    
    
    
    //MARK: Views
    var iPadTabsView: some View {
        HStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabs, id: \.id) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            HStack {
                                HStack {
                                    if selectedTab == tab {
                                        Button(action: {
                                            removeTab(tab)
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
                                        Image(systemName: "slash.circle.fill")
                                            .fontWeight(.medium)
                                            .padding(.leading, 0)
                                    }
                                    
                                    Text(tab.name)
                                }
                                .padding(.horizontal, 15)
                            }
                            .frame(height: 35)
                            .background(selectedTab == tab ? Color(.systemGray4) : Color(.systemGray6))
                            .foregroundColor(selectedTab == tab ? Color(.secondaryLabel) : Color(.label).opacity(0.8))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .cornerRadius(10)
            
            Button {
                addTab()
            } label: {
                Image(systemName: "plus")
            }
            .padding(.horizontal, 5)
            .tint(.teal)
            
            Button {
                
            } label: {
                Image(systemName: "list.bullet")
            }
            .padding(.trailing, 5)
            .tint(.teal)
        }
    }
    
    var iPhoneTabView: some View {
        VStack {
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabs, id: \.id) { tab in
                        HStack(spacing: 0) {
                            Text(tab.name)
                                .font(.system(size: 17, weight: .regular))
                                .padding()
                                .padding([.leading], 5.5)
                            
                            Spacer()
                            
                            Button {
                                addTab()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .padding(.horizontal, 8)
                            .tint(.teal)
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "list.bullet")
                            }
                            .padding(.trailing, 20)
                            .tint(.teal)
                        }
                        .background(
                            BlurView(style: .systemThinMaterial)
                        )
                        .cornerRadius(18)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 25)
//                        .frame(minWidth: UIScreen.main.bounds.width - 60)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
//                        .padding([.all], 30)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, 0)
            }
            .contentMargins(25, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .padding(.bottom, 30)
        }
    }
    
    
    
    //MARK: Main methods
    private func addTab() {
        let newTab = Tab(id: UUID() , name: "blinksh/\(tabs.count + 1)")
        tabs.append(newTab)
        selectedTab = newTab
    }
    
    private func removeTab(_ tab: Tab) {
        if let index = tabs.firstIndex(of: tab) {
            if selectedTab == tab {
                if tabs.count != 1 {
                    selectedTab = tabs[index - 1]
                }
            }
            
            tabs.remove(at: index)
        }
    }
}


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
