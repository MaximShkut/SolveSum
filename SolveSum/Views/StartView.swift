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
    @State private var showOperationView = false
    
    var body: some View {
        NavigationView {
            ZStack {
//                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
//                    .ignoresSafeArea()
                Color.mint.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    NavigationLink(destination: OperationView()) {
                        Text("Start Game")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
//                    Button(action: {
//                        showConfigurationView.toggle()
//                    }, label: {
//                        Text("Configuration")
//                    })
//                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    Button(action: {
                        //exit(0)
                    }, label: {
                        Text("Exit")
                    })
                    .buttonStyle(StyleForButtonInPreviewScreen())
                }
                .padding()
                
//                if showConfigurationView {
//                    Color.black.opacity(0.5)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            showConfigurationView = false
//                        }
//                    VStack(spacing: 20) {
//                        ConfigurationView(isPresented: $showConfigurationView).environmentObject(viewModel)
//                    }
//                    .offset(y: UIScreen.height / 2 - 450)
//                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
