//
//  SolveSumApp.swift
//  SolveSum
//
//  Created by user236450 on 6/4/23.
//

import SwiftUI
import Firebase

@main
struct SolveSumApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(dataManager)
                .onAppear {
                    dataManager.fetchUsers()
                }
        }
    }
}
