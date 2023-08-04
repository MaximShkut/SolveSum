//
//  StartView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI
import FirebaseAuth

struct StartView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mint.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    NavigationLink(destination: OperationView()) {
                        Text("Start Game")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    NavigationLink(destination: LeaderBoard()) {
                        Text("Leader Board")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    NavigationLink(destination: UserSettingsView()) {
                        Text("User Settings")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                }
                .padding()
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
