//
//  CellViewModel.swift
//  shruk_application
//
//  Created by Yahor Hreben on 25.06.23.
//

import Foundation
import UIKit
import SwiftUI

class CellViewModel: ObservableObject {
    @Published var cells: [CellModel] = []
    @Published var sizeOfTable: Int = 5
    @Published var sizeOfCell: CGFloat = 0
    @Published var goalNumber: Int = 0
    
    var paddingHorizontal: CGFloat = 20
    
    func clickOnCell(cell: CellModel) {
        if let index = cells.firstIndex(where: { $0.id == cell.id }) {
            cells[index].isClicked.toggle()
            if goalNumber == sumClickedCells {
                self.deleteClickedCells()
                self.moveCells()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.rewriteTable()
                }
            }
        }
    }
    
    var sumClickedCells: Int {
        cells.filter( { $0.isClicked }).map { $0.number }.reduce(0, +)
    }
    
    func clickHelp() {
        if let items = findItems(for: goalNumber, in: cells.filter( { !$0.isDeleted }).map { $0.number }).first {
            for number in items {
                if let cell = cells.first(where: { $0.number == number && !$0.isHelp && !$0.isDeleted }) {
                    if let index = cells.firstIndex(where: { $0.id == cell.id }) {
                        withAnimation {
                            cells[index].isHelp = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.cells[index].isHelp = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteClickedCells() {
        for clickedCell in cells.filter({ $0.isClicked}) {
            if let index = cells.firstIndex(where: {$0.id == clickedCell.id}) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    cells[index].isDeleted = true
                    cells[index].isClicked = false
                }
            }
        }
    }
    
    func addNewCell() {
        if let indexPair = cells.filter({ $0.isDeleted}).map({ $0.index }).sorted(by: { $0.row > $1.row }).first{
            if let cell = getCell(row: indexPair.row, column: indexPair.column) {
                if let index = cells.firstIndex(where: { $0.id == cell.id }) {
                    cells[index].isDeleted = false
                    cells[index].number = Int.random(in: 1..<10)
                    cells[index].offsetY = -sizeOfCell
                    withAnimation(.easeOut) {
                        let cells1 = cells.filter({ $0.offsetY != 0 })
                        self.cells[index].offsetY = 0
                    }
                }
            }
        }
    }
    
    private func findItems(for targetSum: Int, in numbers: [Int]) -> [[Int]] {
        var combinations: [[Int]] = []
        var currentCombination: [Int] = []

        findCombinations(for: targetSum, in: numbers, startingIndex: 0, currentCombination: &currentCombination, combinations: &combinations)
        return combinations
    }

    private func findCombinations(for targetSum: Int, in numbers: [Int], startingIndex: Int, currentCombination: inout [Int], combinations: inout [[Int]]) {
        if targetSum == 0 {
            combinations.append(currentCombination)
            return
        }

        if targetSum < 0 || startingIndex >= numbers.count {
            return
        }

        for i in startingIndex..<numbers.count {
            let num = numbers[i]
            currentCombination.append(num)
            findCombinations(for: targetSum - num, in: numbers, startingIndex: i + 1, currentCombination: &currentCombination, combinations: &combinations)
            currentCombination.removeLast()
        }
    }
    
    func getColumn(by index: Int) -> [CellModel] {
        cells.filter({ $0.index.column == index}).sorted{ $0.index.row > $1.index.row }
    }
    
    func rewriteTable() {
        for column in 0..<sizeOfTable {
            var value: Int = 0
            for cell in getColumn(by: column) {
                if let index = cells.firstIndex(where: {$0.id == cell.id}) {
                    if cell.isDeleted {
                        let moveIndex = self.cells.filter { $0.index.column == column}.filter { $0.index.row < cell.index.row && !$0.isDeleted}.count
                        self.cells[index].index = Index(row: cell.index.row - moveIndex, column: cell.index.column)
                        value += 1
                    } else {
                        self.cells[index].index = Index(row: cell.index.row + value, column: cell.index.column)
                        self.cells[index].offsetY = 0
                    }
                }
            }
        }
    }
    
    func moveCells() {
        for column in 0..<sizeOfTable {
            var value: Int = 0
            for cell in getColumn(by: column) {
                if let index = cells.firstIndex(where: {$0.id == cell.id}) {
                    if cell.isDeleted {
                        value += 1
                    } else {
                        withAnimation(.easeOut) {
                            self.cells[index].offsetY = CGFloat(value) * (self.sizeOfCell + 8)
                        }
                    }
                }
            }
        }
    }
    
    func getCell(row: Int, column: Int) -> CellModel? {
        if let index = cells.firstIndex(where: { $0.index == Index(row: row, column: column)}) {
            return cells[index]
        }
        return nil
    }
    
    private func calculateSizeOfCell() {
        let widthScreen = UIScreen.width
        self.sizeOfCell = (widthScreen - (paddingHorizontal * CGFloat(2)) - CGFloat(8 * sizeOfTable)) / CGFloat(sizeOfTable)
    }
    
    private func generateCells() {
        for row in 0..<sizeOfTable {
            for column in 0..<sizeOfTable {
                cells.append(CellModel(index: Index(row: row, column: column), number: Int.random(in: 1..<10)))
            }
        }
    }
    
    private func generateGoalNumber() {
        goalNumber = cells.map { $0.number }.reduce(0, +) / (sizeOfTable * 2)
    }
    
    func loadData() {
        generateCells()
        generateGoalNumber()
        calculateSizeOfCell()
    }
}
