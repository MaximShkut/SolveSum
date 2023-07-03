//
//  GameViewModel.swift
//  SolveSum
//
//  Created by user236450 on 7/2/23.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var gameConfiguration = GameConfiguration()
    @Published var cellSize: CGFloat = 0
    @Published var targetNumber: Int = 0
    @Published var score: Int = 0
    @Published var cells: [CellItem] = []
    
    
    func startGame() {
        score = 0
        generateCells()
        updateTargetNumber()
        calculateCellSize()
    }
    
    func makeEasyConfiguration() {
        gameConfiguration.boardSize = 4
        gameConfiguration.maxCellValue = 6
    }
    
    func makeMediumConfiguration() {
        gameConfiguration.boardSize = 6
        gameConfiguration.maxCellValue = 10
    }
    
    func makeHardConfiguration() {
        gameConfiguration.boardSize = 7
        gameConfiguration.maxCellValue = 14
    }
    
    func makeSuperHardConfiguration() {
        gameConfiguration.boardSize = 8
        gameConfiguration.maxCellValue = 20
    }
    
    func checkProgress() {
        let selectedSum = sumSelectedNumbers()
        if selectedSum == self.targetNumber {
            let allCells = cells.compactMap { $0 }.filter { $0.isSelected }
            for cell in allCells {
                if let index = cells.firstIndex(of: cell){
                    cells[index].isDeleted = true
                    cells[index].isSelected = false
                }
            }
            movingCells()
            
            withAnimation(.linear(duration: 1.0)) {
                score += targetNumber
            }
            
            updateTargetNumber()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.rewriteTable()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.addButtonTapped()
            }
            
        }
    }
    
    func getCell(row: Int, column: Int) -> CellItem? {
        return cells.first(where: { $0.row == row && $0.column == column })
    }
    
    func showHint() {
        let selectedCells = cells.filter { !$0.isDeleted }
        let targetSum = targetNumber
        
        // Find combinations of cells that sum up to the target number
        var hintCells: [CellItem] = []
        findCombinations(cells: selectedCells, target: targetSum, currentSum: 0, startIndex: 0, currentCombination: [], hintCells: &hintCells)
        
        withAnimation(.easeInOut(duration: 1)) {
            for cell in hintCells {
                if let index = cells.firstIndex(of: cell) {
                    cells[index].isHint.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    self.hideHint()
                }
            }
        }
    }
    
    private func getCellInColumn(column: Int) -> [CellItem] {
        return cells.filter({$0.column == column}).sorted{ $0.row > $1.row}
    }
    
    private func movingCells() {
        for column in 0..<gameConfiguration.boardSize{
            var value: Int = 0
            for  cell in getCellInColumn(column: column){
                if let index = cells.firstIndex(where: {$0.id == cell.id}){
                    if cell.isDeleted{
                        value += 1
                    }
                    else{
                        withAnimation(.easeOut(duration: 0.3)) {
                            cells[index].offset = CGFloat(value) * (self.cellSize + 10)
                        }
                    }
                }
            }
        }
    }
    
    private func rewriteTable(){
        for column in 0..<gameConfiguration.boardSize{
            var value: Int = 0
            for  cell in getCellInColumn(column: column){
                if let index = cells.firstIndex(where: {$0.id == cell.id}){
                    if cell.isDeleted{
                        let moveIndex = cells.filter{$0.column == column}.filter{$0.row < cell.row && !$0.isDeleted}.count
                        cells[index].row -= moveIndex
                        value += 1
                    }
                    else{
                        cells[index].row += value
                        cells[index].offset = 0
                    }
                }
            }
        }
    }
    
    private func addButtonTapped() {
        // add once button
        //        if let deletedCells = cells.filter({ $0.isDeleted }).sorted(by: {$0.row > $1.row} ).first{
        //            if let index = cells.firstIndex(of:  deletedCells){
        //                cells[index].value = Int.random(in: 1...config.maxCellValue)
        //                cells[index].isDeleted = false
        //                cells[index].isHint = false
        //            }
        //        }
        
        //add all button
        let allCells = cells.filter { $0.isDeleted }
        for cell in allCells {
            if let index = cells.firstIndex(of: cell){
                cells[index].value = Int.random(in: 1...gameConfiguration.maxCellValue)
                cells[index].isDeleted = false
                cells[index].isHint = false
            }
        }
    }
    
    private func sumSelectedNumbers () -> Int {
        cells.compactMap {$0 }.filter { $0.isSelected && !$0.isDeleted  }.reduce(0) { $0 + ($1.value ) }
    }
    
    private func updateTargetNumber() {
        var arr = cells.compactMap { $0 }
        var sum = 0
        var cellsCount = 0
        
        // тут лучше выше среднего чтобы сумма была, а то одни 10 будут
        while sum < gameConfiguration.maxCellValue && cellsCount < gameConfiguration.maxCellsToSelect {
            arr = arr.shuffled()
            sum += arr.popLast()!.value
            cellsCount += 1
        }
        
        self.targetNumber = sum
    }
    
    private func generateCells() {
        self.cells = []
        for row in 0..<gameConfiguration.boardSize {
            for col in 0..<gameConfiguration.boardSize {
                let value = Int.random(in: 1...gameConfiguration.maxCellValue)
                let cell = CellItem(value: value, row: row, column: col)
                cells.append(cell)
            }
        }
    }
    
    
    
    private func calculateCellSize() {
        let boardSize = gameConfiguration.boardSize
        var widthScreen = UIScreen.screenWidth
        widthScreen -= 20 * CGFloat(2)
        widthScreen -=  CGFloat(10 * (boardSize - 1))
        self.cellSize = widthScreen / CGFloat(boardSize)
    }
    
    
    
    
    private func hideHint() {
        let selectedCells = cells.filter { !$0.isDeleted }
        for cell in selectedCells {
            if let index = self.cells.firstIndex(of: cell) {
                self.cells[index].isHint = false
            }
        }
    }
    
    private func findCombinations(cells: [CellItem], target: Int, currentSum: Int, startIndex: Int, currentCombination: [CellItem], hintCells: inout [CellItem]) {
        if currentSum == target {
            hintCells.append(contentsOf: currentCombination)
            return
        }
        
        if currentSum > target || startIndex >= cells.count {
            return
        }
        
        for i in startIndex..<cells.count {
            var newCombination = currentCombination
            newCombination.append(cells[i])
            
            let newSum = currentSum + cells[i].value
            findCombinations(cells: cells, target: target, currentSum: newSum, startIndex: i + 1, currentCombination: newCombination, hintCells: &hintCells)
            
            if hintCells.count > 0 {
                break
            }
        }
    }
}
