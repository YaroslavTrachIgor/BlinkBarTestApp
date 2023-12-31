//
//  TabsEditSheetView.swift
//  BlinkBarTestApp
//
//  Created by User on 2023-12-30.
//

import Foundation
import SwiftUI

struct TabsEditSheetView: View {
    
    @ObservedObject var tabsManager: TabsManager
    
    @State private var editMode: EditMode = .inactive
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tabsManager.tabs) { tab in
                    HStack {
                        Text(tab.name)
                        
                        Spacer()
                        
                        if tabsManager.selectedTab == tab {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.teal)
                                .fontWeight(.medium)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if editMode == .inactive {
                            tabsManager.setNewSelected(tab)
                        }
                    }
                }
                .onDelete { indexSet in
                    guard tabsManager.tabs.count > 1 else {
                        return // Prevent deletion if there's only one tab
                    }
                    let indexes = Array(indexSet)
                    tabsManager.removeTabs(at: indexes)
                }
                .onMove { from, to in
                    tabsManager.tabs.move(fromOffsets: from, toOffset: to)
                }
            }
            .onAppear {
                let tableHeaderView = UIView(frame: .zero)
                tableHeaderView.frame.size.height = 1
                UITableView.appearance().tableHeaderView = tableHeaderView
            }
            .navigationBarItems(
                leading: EditButton().foregroundColor(Color.teal),
                trailing:Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Image(systemName: "multiply")
                            .foregroundColor(Color(.systemGray))
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 11))
                            .fontWeight(.semibold)
                            .padding(.all, 6)
                    }
                    .background(Color(.systemGray4).opacity(0.5))
                    .cornerRadius(12)
                }
            )
            .environment(\.editMode, $editMode)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Tabs")
            .onAppear {
                
                // Refresh the view when tabsManager.tabs is updated
                NotificationCenter.default.addObserver(forName: .tabsUpdated, object: nil, queue: .main) { _ in
                    
                    // This will force the view to refresh when tabs are updated
                    tabsManager.objectWillChange.send()
                }
            }
        }
    }
}
