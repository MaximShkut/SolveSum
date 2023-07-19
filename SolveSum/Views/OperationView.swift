//
//  OperationView.swift
//  SolveSum
//
//  Created by user236450 on 7/17/23.
//

import Foundation
import SwiftUI

struct OperationView: View {
    @Environment(\.presentationMode) var presentation
    @State private var operations: [String] = ["Plus", "Multiplication"]
    
    var body: some View {
        NavigationView{
            ZStack {
                //LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
                Color.mint.opacity(0.4)
                    .ignoresSafeArea()
                
                //Image("plus")
                VStack(spacing: 10) {
                    ForEach(0..<operations.count, id: \.self) {operation in
                        NavigationLink(destination: LevelsView()) {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(height: 100)
                                .foregroundColor(.blue.opacity(0.4))
                                .overlay (
                                    ZStack {
                                        HStack {
                                            Text("\(operations[operation])")
                                                .font(.system(size: 20))
                                                .fontWeight(.black)
                                                .padding()
                                                .padding(.bottom, 50)
                                            Spacer()
                                            Image("\(operations[operation])")
                                                .resizable()
                                                .frame(width: 70, height: 70)
                                        }
                                    }
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
            }
            .navigationTitle("Operations")
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct OperationView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
