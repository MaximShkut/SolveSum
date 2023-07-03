//
//  StartView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel = GameViewModel()
    @State private var showConfigurationView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: StartGame().environmentObject(viewModel)) {
                        Text("Start Game")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    Button(action: {
                        //exit(0)
                    }, label: {
                        Text("Exit")
                    })
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    Button(action: {
                        showConfigurationView.toggle()
                    }, label: {
                        Text("Configuration")
                    })
                    .buttonStyle(StyleForButtonInPreviewScreen())
                }
                .padding()
                
                if showConfigurationView {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showConfigurationView = false
                        }
                    VStack(spacing: 20) {
                        ConfigurationView(isPresented: $showConfigurationView).environmentObject(viewModel)
                    }
                    .offset(y: UIScreen.screenHeight / 2 - 450)
                }
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
