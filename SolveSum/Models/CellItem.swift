//
//  CellItem.swift
//  SolveSum
//
//  Created by user236450 on 7/2/23.
//
import SwiftUI
import Foundation

struct CellItem: Identifiable, Hashable {
    let id = UUID()
    var value: Int
    var row: Int
    var column: Int
    var isSelected: Bool = false
    var isDeleted: Bool = false
    var isHint: Bool = false
    var offset: CGFloat = 0
    var cellOpacity: Double = 1.0
}
