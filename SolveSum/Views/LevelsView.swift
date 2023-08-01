//
//  LevelsView.swift
//  SolveSum
//
//  Created by user236450 on 7/17/23.
//

import Foundation
import SwiftUI

struct LevelsView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var viewModel: GameViewModel
    @State private var viewIsOn = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.mint.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    ForEach(0..<11, id: \.self) {id in
                        NavigationLink(isActive: $viewIsOn) {
                            GameView().environmentObject(viewModel)
                        } label: {
                            Button(action: {
                                if id != 10 {
                                    viewModel.gameConfiguration.maxCellValue = 2 * (id + 1)
                                    viewModel.gameConfiguration.boardSize = 2 + (id / 2)
                                    viewModel.gameConfiguration.countAddCell = 2 + (id + 1)
                                } else {
                                    viewModel.gameConfiguration.countDownTimer = 120
                                    viewModel.gameConfiguration.countAddCell = 1000
                                    viewModel.gameConfiguration.boardSize = 6
                                    viewModel.gameConfiguration.maxCellValue = 10
                                }
                                viewIsOn.toggle()
                            }, label: {
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(height: 45)
                                    .foregroundColor(.blue.opacity(0.4))
                                    .overlay(
                                        Text(id != 10 ? "\(id + 1) level" : "Time Level")
                                            .font(.system(size: 20))
                                            .fontWeight(.black)
                                            .padding()
                                    )
                            })
                        }
                    }
                    .padding(.leading, 50)
                    .padding(.trailing, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Back")
                    })
                }
                .navigationBarBackButtonHidden(true)
                
                
            }
            .navigationTitle("Levels")
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
