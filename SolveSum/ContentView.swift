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
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: StartGame()) {
                        Text("Start Game")
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                    Button("Exit"){
                        //exit(0)
                    }
                    .buttonStyle(StyleForButtonInPreviewScreen())
                }
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
}

struct StartGame: View {
    
    private let cellSize: CGFloat = 25
    private let config = GameConfiguration()
    @State private var targetNumber = 0
    @State private var cells: [CellItem] = []
    
    var body: some View{
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text("\(targetNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                ForEach(0..<config.boardSize, id: \.self) { row in
                    HStack {
                        ForEach(0..<config.boardSize, id: \.self) { column in
                            if let cell = getCell(row: row, column: column){
                                if !cell.isDeleted{
                                    Button(action: {
                                        if let index = cells.firstIndex(of: cell){
                                            cells[index].isSelected.toggle()
                                            checkProgress()
                                        }
                                    }){
                                        Text("\(cell.value)")
                                            .frame(width: cellSize, height: cellSize)
                                            .padding()
                                            .background(cell.isSelected ? .green : .blue)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(10)
                                    }}
                                else{
                                    Rectangle()
                                        .frame(width: cellSize, height: cellSize)
                                        .background(Color.red)
                                        .padding()
                                        .opacity(0)
                                        .cornerRadius(10)
                                        .zIndex(100)
                                }
                            }
                        }
                    }
                }
                
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
                Button(action: addButtonTapped) {
                    Text("Add")
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
            var value = 0
            for  cell in getCellInColumn(column: column){
                if let index = cells.firstIndex(of: cell){
                    if cell.isDeleted{
                        let moveIndex = cells.filter{$0.column == column}.filter{$0.row < cell.row && !$0.isDeleted}.count
                        cells[index].row -= moveIndex
                        value += 1
                    }
                    else{
                        withAnimation{
                            cells[index].row += value
                        }
                    }
                }
            }
        }
    }
    
    private func addButtonTapped() {
        let allCells = cells.compactMap { $0 }.filter { $0.isDeleted }
        for cell in allCells {
            if let index = cells.firstIndex(of: cell){
                withAnimation{
                    cells[index].value = Int.random(in: 1...config.maxCellValue)
                    cells[index].isDeleted = false
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
                    withAnimation{
                        cells[index].isDeleted = true
                        cells[index].isSelected = false
                    }
                }
            }
            movingCells()
            updateTargetNumber()
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
    
    private func startGame() {
        generateCells()
        updateTargetNumber()
    }
    
    private func getCell(row: Int, column: Int) -> CellItem? {
        return cells.first(where: { $0.row == row && $0.column == column })
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
