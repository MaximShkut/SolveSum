//
//  StartView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel = GameViewModel()
    
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
                    
                    Button(action: {
                        //exit(0)
                    }, label: {
                        Text("Leader Board")
                    })
                    .buttonStyle(StyleForButtonInPreviewScreen())
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
