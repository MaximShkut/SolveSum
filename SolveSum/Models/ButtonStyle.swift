//
//  ButtonStyle.swift
//  SolveSum
//
//  Created by user236450 on 7/2/23.
//

import SwiftUI
import Foundation

struct StyleForButtonInPreviewScreen: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .padding()
            .background(.gray)
            .cornerRadius(20)
    }
}

struct StyleForButtonInCongigurationView: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.purple)
            .background(
                Capsule()
                    .stroke(Color.purple, lineWidth: 5)
                    .background(Color.white)
                    .cornerRadius(20)
                    .scaleEffect(configuration.isPressed ? 0.8 : 1.0) // Изменение размера при нажатии
            )
    }
}
