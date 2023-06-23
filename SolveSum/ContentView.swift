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
    var value: Int?
    let row: Int
    let column: Int
    var isSelected: Bool = false
    var isDeleted: Bool = false
}

struct StartGame: View {
    
    private let cellSize: CGFloat = 25
    private let config = GameConfiguration()
    @State private var targetNumber = 0
    @State private var cells: [[CellItem]] = [[]]
    
    var body: some View{
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text("\(targetNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                ForEach(cells, id: \.self) { row in
                    HStack {
                        ForEach(row) { cell in
                            Button(action: {
                                cells[cell.row][cell.column].isSelected = !cells[cell.row][cell.column].isSelected
                                checkProgress()
                            }) {
                                if let value = cell.value{
                                    Text("\(value)")
                                        .frame(width: cellSize, height: cellSize)
                                        .padding()
                                        .background(cell.isSelected ? .green : .blue)
                                        .animation(.easeInOut(duration: cell.isSelected ? 0.2 : 0.2 ))
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .cornerRadius(10)
                                }
                                else{
                                    Rectangle()
                                        .frame(width: cellSize, height: cellSize)
                                        .padding()
                                        .background(Color.clear)
                                        .opacity(0)
                                        .cornerRadius(10)
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
    
    func addButtonTapped() {
                
        var emptyCells: [(row: Int, column: Int)] = []
        for row in 0..<config.boardSize {
            for column in 0..<config.boardSize {
                if cells[row][column].value == nil {
                    emptyCells.append((row, column))
                }
            }
        }
        
        if let randomEmptyCell = emptyCells.randomElement() {
            cells[randomEmptyCell.row][randomEmptyCell.column].value = Int.random(in: 1...config.maxCellValue)
        }
    }
    
    private func removeDeletedCells() {
        cells = cells.map { row in
            row.map { cell in
                if cell.isDeleted {
                    return CellItem(value: nil, row: cell.row, column: cell.column, isSelected: false, isDeleted: false)
                } else {
                    return cell
                }
            }
        }
    }
    
    private func checkProgress() {
        let selectedSum = sumSelectedNumber()
        if selectedSum == self.targetNumber {
            let allCells = cells.flatMap { $0 }.filter { $0.isSelected && !$0.isDeleted }
            for cell in allCells {
                cells[cell.row][cell.column].isDeleted = true
            }
            removeDeletedCells()
            updateTargetNumber()
        }
    }
    
    private func sumSelectedNumber () -> Int {
        cells.flatMap {$0 }.filter { $0.isSelected && !$0.isDeleted  }.reduce(0) { $0 + ($1.value ?? 0) }
    }
    
    private func updateTargetNumber() {
        var arr = cells.flatMap { $0 }
        var sum = 0
        var cellsCount = 0
        
        // тут лучше выше среднего чтобы сумма была, а то одни 10 будут
        while sum < config.maxCellValue && cellsCount < config.maxCellsToSelect {
            arr = arr.shuffled()
            sum += arr.popLast()!.value ?? 0
            cellsCount += 1
        }
        
        self.targetNumber = sum
    }
    
    private func generateCells() {
        self.cells = []
        for row in 0..<config.boardSize {
            cells.append([])
            for col in 0..<config.boardSize {
                let value = Int.random(in: 1...config.maxCellValue)
                let cell = CellItem(value: value, row: row, column: col)
                cells[row].append(cell)
            }
        }
        removeDeletedCells()
    }
    
    private func startGame() {
        generateCells()
        updateTargetNumber()
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
