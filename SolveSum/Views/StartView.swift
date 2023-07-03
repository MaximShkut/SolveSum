//
//  StartView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel = GameViewModel()
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: StartGame().environmentObject(viewModel)) {
                        Text("Start Game")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    Button("Exit") {
                        //exit(0)
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    Button("Configuration") {
                        showSettings = true
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    .actionSheet(isPresented: $showSettings) {
                        ActionSheet(
                            title: Text("Game Configuration"),
                            message: Text("Configure game difficulty and board size"),
                            buttons: [
                                .default(Text("Easy")) {
                                    viewModel.makeEasyConfiguration()
                                },
                                .default(Text("Medium")) {
                                    viewModel.makeEasyConfiguration()
                                },
                                .default(Text("Hard")) {
                                    viewModel.makeEasyConfiguration()
                                },
                                .cancel()
                            ]
                        )
                    }
                }
                .padding()
            }
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
