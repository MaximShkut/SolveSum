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
