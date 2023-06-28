//
//  CellModel.swift
//  shruk_application
//
//  Created by Yahor Hreben on 25.06.23.
//

import Foundation

typealias Index = (row:Int, column:Int)

struct CellModel: Identifiable {
    var id: UUID = .init()
    var index: Index
    var number: Int
    var isHelp: Bool = false
    var isClicked: Bool = false
    var isDeleted: Bool = false
    var offsetY: CGFloat = 0
}
