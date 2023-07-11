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
                HStack(spacing: 8){
                    Button(action: {
                        isPressed.toggle()
                        if isPressed {
                            viewModel.gameConfiguration.arithmeticSign = "+"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                isPresented = false
                            }
                        }
                    }, label: {
                        Text("+")
                    })
                    .buttonStyle(StyleForButtonInCongigurationViewForSign())
                    
                    Button(action: {
                        isPressed.toggle()
                        if isPressed {
                            viewModel.gameConfiguration.arithmeticSign = "*"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                isPresented = false
                            }
                        }
                    }, label: {
                        Text("*")
                    })
                    .buttonStyle(StyleForButtonInCongigurationViewForSign())
                }
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
                        viewModel.makeMediumConfiguration()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            isPresented = false
                        }
                    }
                }, label: {
                    VStack {
                        Text("Infinity")
                            .offset(y: +40)
                        Slider(value: Binding<Double>(
                            get: { Double(viewModel.gameConfiguration.countDownTimer) },
                            set: { viewModel.gameConfiguration.countDownTimer = Int($0) }
                        ), in: 0...600, step: 10)
                        .padding()
                        Text("\(viewModel.gameConfiguration.countDownTimer / 60)")
                            .offset(y: -40)
                    }
                    
                })
                .buttonStyle(StyleForButtonInCongigurationView())
                
//                Button(action: {
//                    isPressed.toggle()
//                    if isPressed {
//                        viewModel.makeSuperHardConfiguration()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                            isPresented = false
//                        }
//                    }
//                }, label: {
//                    Text("SuperHard")
//                })
//                .buttonStyle(StyleForButtonInCongigurationView())
            }
            .padding()
        }
        .background(Color.gray.opacity(0.8))
        .cornerRadius(10)
    }
}
