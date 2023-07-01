//
//  ContentView.swift
//  SolveSumFromV
//
//  Created by user236450 on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showStartGameView = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: StartGame()) {
                        Text("Start Game")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    
                    Button("Exit") {
                        //exit(0)
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                }
                .padding()
            }
            .ignoresSafeArea()
        }
    }
}

struct CellItem: Identifiable, Hashable {
    let id = UUID()
    var value: Int
    var row: Int
    var column: Int
    var isSelected: Bool = false
    var isDeleted: Bool = false
    var isHint: Bool = false
    var offset: CGFloat = 0
}

struct StartGame: View {
    private let config = GameConfiguration()
    @State private var cellSize: CGFloat = 0
    @State private var targetNumber = 0
    @State private var cells: [CellItem] = []
    
    var body: some View{
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
            
            
            VStack(spacing: 10) {
                GeometryReader{ geometry in
                    HStack(){
                        Spacer()
                        Text("\(targetNumber)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(width: geometry.size.width * 0.55)
                        
                        Button(action: {
                            startShowHint()
                        }, label: {
                            Image(systemName: "lightbulb")
                                .font(.title)
                                .foregroundColor(.yellow)
                        })
                        .padding(8)
                        .background(.gray)
                        .clipShape(Circle())
                        .frame(width: geometry.size.width * 0.15)
                    }
                    .padding()
                }
                .frame(height: 70)
                
                
                
                ForEach(0..<config.boardSize, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<config.boardSize, id: \.self) { column in
                            if let cell = getCell(row: row, column: column){
                                if !cell.isDeleted{
                                    Button(action: {
                                        if let index = cells.firstIndex(of: cell){
                                            cells[index].isSelected.toggle()
                                            checkProgress()
                                        }
                                    }, label: {
                                        Text("\(cell.value)")
                                    })
                                    .frame(width: cellSize, height: cellSize)
                                    .background(Group{
                                        if cell.isSelected{
                                            Color.green
                                        }
                                        else if cell.isHint{
                                            Color.yellow
                                        }
                                        else{
                                            Color.blue
                                        }
                                    })
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .cornerRadius(10)
                                    .offset(y: cell.offset)
                                }
                                else{
                                    Rectangle()
                                        .frame(width: cellSize, height: cellSize)
                                        .opacity(0)
                                }
                            }
                        }
                    }
                }
                HStack{
                    Button(action: {
                        startGame()
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        addButtonTapped()
                    }, label: {
                        Text("Add Button")
                    })
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    
                }
            }
            .onAppear{
                startGame()
            }
        }
        .ignoresSafeArea()
    }
    
    private func getCellInColumn(column: Int) -> [CellItem] {
        return cells.filter({$0.column == column}).sorted{ $0.row > $1.row}
    }
    
    private func movingCells() {
        for column in 0..<config.boardSize{
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
    
    private func rewriteField(){
        for column in 0..<config.boardSize{
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
        if let deletedCells = cells.filter({ $0.isDeleted }).sorted(by: {$0.row > $1.row} ).first{
            if let index = cells.firstIndex(of:  deletedCells){
                withAnimation(.easeOut(duration: 0.3)){
                    cells[index].value = Int.random(in: 1...config.maxCellValue)
                    cells[index].isDeleted = false
                    cells[index].isHint = false
                }
            }
        }
    }
    
    private func checkProgress() {
        
        let selectedSum = sumSelectedNumber()
        if selectedSum == self.targetNumber {
            let allCells = cells.compactMap { $0 }.filter { $0.isSelected }
            for cell in allCells {
                if let index = cells.firstIndex(of: cell){
                    cells[index].isDeleted = true
                    cells[index].isSelected = false
                }
            }
            movingCells()
            updateTargetNumber()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                rewriteField()
            }
        }
    }
    
    private func sumSelectedNumber () -> Int {
        cells.compactMap {$0 }.filter { $0.isSelected && !$0.isDeleted  }.reduce(0) { $0 + ($1.value ) }
    }
    
    private func updateTargetNumber() {
        var arr = cells.compactMap { $0 }
        var sum = 0
        var cellsCount = 0
        
        // тут лучше выше среднего чтобы сумма была, а то одни 10 будут
        while sum < config.maxCellValue && cellsCount < config.maxCellsToSelect {
            arr = arr.shuffled()
            sum += arr.popLast()!.value
            cellsCount += 1
        }
        
        self.targetNumber = sum
    }
    
    private func generateCells() {
        self.cells = []
        for row in 0..<config.boardSize {
            for col in 0..<config.boardSize {
                let value = Int.random(in: 1...config.maxCellValue)
                let cell = CellItem(value: value, row: row, column: col)
                cells.append(cell)
            }
        }
    }
    
    private func getCell(row: Int, column: Int) -> CellItem? {
        return cells.first(where: { $0.row == row && $0.column == column })
    }
    
    private func getCellSize(){
        let boardSize = config.boardSize
        var widthScreen = UIScreen.screenWidth
        widthScreen -= 20 * CGFloat(2)
        widthScreen -=  CGFloat(10 * (boardSize - 1))
        self.cellSize = widthScreen / CGFloat(boardSize)
    }
    
    private func showHint() {
        let selectedCells = cells.filter { !$0.isDeleted }
        let targetSum = targetNumber
        
        // Find combinations of cells that sum up to the target number
        var hintCells: [CellItem] = []
        findCombinations(cells: selectedCells, target: targetSum, currentSum: 0, startIndex: 0, currentCombination: [], hintCells: &hintCells)
        
            withAnimation(.easeInOut(duration: 1).repeatCount(1)) {
                for cell in hintCells {
                    if let index = cells.firstIndex(of: cell) {
                        cells[index].isHint.toggle()
                    }
                }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    hideHint()
                }
            }
        }
    }


    private func hideHint(){
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

    
    private func startShowHint()
    {
        showHint()
    }
    private func startGame() {
        generateCells()
        updateTargetNumber()
        getCellSize()
    }
}



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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
