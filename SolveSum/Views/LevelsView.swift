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
    @ObservedObject var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.mint.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    ForEach(0..<10, id: \.self) {id in
                        NavigationLink(destination: GameView().environmentObject(viewModel)) {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(height: 50)
                                .foregroundColor(.blue.opacity(0.4))
                                .overlay(
                                    Text("\(id + 1) level")
                                        .font(.system(size: 20))
                                        .fontWeight(.black)
                                        .padding()
                                )
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
