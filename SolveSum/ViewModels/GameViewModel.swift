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
    @Published var selectedTime: Int = 0
    
    func formattedTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startGame() {
        score = 0
        generateCells()
        calculateCellSize()
        if gameConfiguration.arithmeticSign == "Plus" {
            updateTargetNumberForPlus()
        } else if gameConfiguration.arithmeticSign == "Multiplication" {
            updateTargetNumberForMultiplication()
        }
        
    }
    
    func checkProgress() {
        var selectedSum: Int = 0
        if gameConfiguration.arithmeticSign == "Plus" {
            selectedSum = sumSelectedNumbers()
        } else if gameConfiguration.arithmeticSign == "Multiplication" {
            selectedSum = sumMyltiplicationSelectedNumbers()
        }
        if selectedSum == self.targetNumber {
            let allCells = cells.compactMap { $0 }.filter { $0.isSelected }
            for cell in allCells {
                if let index = cells.firstIndex(of: cell){
                    cells[index].isDeleted = true
                    cells[index].isSelected = false
                }
            }
            movingCells()
            
            withAnimation(.linear(duration: 0.5)) {
                score += targetNumber
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.rewriteTable()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                //self.changeTargetNumberOverTime()
                self.addCell()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                if self.gameConfiguration.arithmeticSign == "Plus" {
                    self.updateTargetNumberForPlus()
                } else if self.gameConfiguration.arithmeticSign == "Multiplication" {
                    self.updateTargetNumberForMultiplication()
                }
            }
        }
    }
    
    func changeTargetNumberOverTime() {
        let timer = 120
        let remainingTime = gameConfiguration.countDownTimer
        let changer = (timer - remainingTime) / 10
        gameConfiguration.maxCellValue = 10 + (2 * changer)
    }
    
    func getCell(row: Int, column: Int) -> CellItem? {
        return cells.first(where: { $0.row == row && $0.column == column })
    }
    
    func showHint() {
        let selectedCells = cells.filter { !$0.isDeleted }
        let targetSum = targetNumber
        
        var hintCells: [CellItem] = []
        
        if gameConfiguration.arithmeticSign == "Plus" {
            findCombinationsForPlus(cells: selectedCells, target: targetSum, currentSum: 0, startIndex: 0, currentCombination: [], hintCells: &hintCells)
        } else if gameConfiguration.arithmeticSign == "Multiplication" {
            findCombinationsForMyltiplication(cells: selectedCells, target: targetSum, currentProduct: 1, startIndex: 0, currentCombination: [], hintCells: &hintCells)
        }
        
        
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
                        withAnimation(.easeOut(duration: 0.2)) {
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
    
    func addCell() {
        let allCells = cells.filter { $0.isDeleted }
        for cell in allCells {
            if let index = cells.firstIndex(of: cell){
                if gameConfiguration.countAddCell > 0 {
                    if gameConfiguration.arithmeticSign == "Plus" {
                        cells[index].value = Int.random(in: 1...gameConfiguration.maxCellValue)
                    } else if gameConfiguration.arithmeticSign == "Multiplication" {
                        cells[index].value = Int.random(in: 2...gameConfiguration.maxCellValue)
                    }
                    cells[index].isDeleted = false
                    cells[index].isHint = false
                    cells[index].offset = -cellSize
                    cells[index].cellOpacity = 0
                    withAnimation(.easeOut) {
                        cells[index].offset = 0
                        cells[index].cellOpacity = 1
                    }
                    
                    gameConfiguration.countAddCell -= 1
                }
            }
        }
    }
    
    private func sumSelectedNumbers () -> Int {
        cells.compactMap {$0 }.filter { $0.isSelected && !$0.isDeleted  }.reduce(0) { $0 + ($1.value ) }
    }
    
    private func sumMyltiplicationSelectedNumbers () -> Int {
        cells.compactMap {$0 }.filter { $0.isSelected && !$0.isDeleted  }.reduce(1) { $0 * ($1.value ) }
    }
    
    private func updateTargetNumberForMultiplication() {
        var arr = cells.compactMap { $0 }.filter { !$0.isDeleted }
        var product = 1
        var cellsCount = 0
        
        // Умножаем числа, пока произведение меньше максимального значения ячейки и количество выбранных ячеек не превышает максимальное
        while product < gameConfiguration.maxCellValue && cellsCount < gameConfiguration.maxCellsToSelect {
            if arr.isEmpty {
                return
            }
            arr = arr.shuffled()
            product *= arr.popLast()!.value
            cellsCount += 1
        }
        
        self.targetNumber = product
    }
    
    private func updateTargetNumberForPlus() {
        var arr = cells.compactMap { $0 }.filter { !$0.isDeleted }
        var sum = 0
        var cellsCount = 0
        
        // тут лучше выше среднего чтобы сумма была, а то одни 10 будут
        while sum < gameConfiguration.maxCellValue && cellsCount < gameConfiguration.maxCellsToSelect {
            if arr.isEmpty {
                return
            }
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
                var value = 0
                if gameConfiguration.arithmeticSign == "Plus" {
                    value = Int.random(in: 1...gameConfiguration.maxCellValue)
                } else if gameConfiguration.arithmeticSign == "Multiplication" {
                    value = Int.random(in: 2...gameConfiguration.maxCellValue)
                }
                let cell = CellItem(value: value, row: row, column: col)
                cells.append(cell)
            }
        }
    }
    
    
    
    private func calculateCellSize() {
        let boardSize = gameConfiguration.boardSize
        var widthScreen = UIScreen.width
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
    
    private func findCombinationsForPlus(cells: [CellItem], target: Int, currentSum: Int, startIndex: Int, currentCombination: [CellItem], hintCells: inout [CellItem]) {
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
            findCombinationsForPlus(cells: cells, target: target, currentSum: newSum, startIndex: i + 1, currentCombination: newCombination, hintCells: &hintCells)
            
            if hintCells.count > 0 {
                break
            }
        }
    }
    
    private func findCombinationsForMyltiplication(cells: [CellItem], target: Int, currentProduct: Int, startIndex: Int, currentCombination: [CellItem], hintCells: inout [CellItem]) {
        if currentProduct == target {
            hintCells.append(contentsOf: currentCombination)
            return
        }
        
        if currentProduct > target || startIndex >= cells.count {
            return
        }
        
        for i in startIndex..<cells.count {
            var newCombination = currentCombination
            newCombination.append(cells[i])
            
            let newProduct = currentProduct * cells[i].value
            findCombinationsForMyltiplication(cells: cells, target: target, currentProduct: newProduct, startIndex: i + 1, currentCombination: newCombination, hintCells: &hintCells)
            
            if hintCells.count > 0 {
                break
            }
        }
    }

}
