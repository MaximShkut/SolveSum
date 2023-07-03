//
//  ConfigurationView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI

struct ConfigurationView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: GameViewModel
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack {
            Text("Configuration")
                .font(.title)
                .padding()
            VStack(spacing: 8) {
                Button(action: {
                    isPressed.toggle()
                    if isPressed {
                        viewModel.makeEasyConfiguration()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            isPresented = false
                        }
                    }
                }, label: {
                    Text("Easy")
                })
                .buttonStyle(StyleForButtonInCongigurationView())
                
                Button(action: {
                    isPressed.toggle()
                    if isPressed {
                        viewModel.makeMediumConfiguration()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            isPresented = false
                        }
                    }
                }, label: {
                    Text("Medium")
                })
                .buttonStyle(StyleForButtonInCongigurationView())
                
                Button(action: {
                    isPressed.toggle()
                    if isPressed {
                        viewModel.makeHardConfiguration()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            isPresented = false
                        }
                    }
                }, label: {
                    Text("Hard")
                })
                .buttonStyle(StyleForButtonInCongigurationView())
                
                Button(action: {
                    isPressed.toggle()
                    if isPressed {
                        viewModel.makeSuperHardConfiguration()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            isPresented = false
                        }
                    }
                }, label: {
                    Text("SuperHard")
                })
                .buttonStyle(StyleForButtonInCongigurationView())
            }
            .padding()
        }
        .background(Color.gray.opacity(0.8))
        .cornerRadius(10)
    }
}
