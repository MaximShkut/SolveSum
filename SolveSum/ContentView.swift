//
//  ContentView.swift
//  SolveSum
//
//  Created by user236450 on 6/4/23.
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

struct StartGame: View {
    
    @State private var selectedButtons: [(row: Int, column: Int)] = []
    @State private var selectedButtonsAndEqualTarget: [(row: Int, column: Int)] = []
    @State private var arrayAllNumber: [Int] = []
    @State private var allSelectedButtons: [Int] = []
    @State private var targetNumber = Int.random(in: 20...40)
    //@State private var numberButtons: [[Int]] = [[]]
    
    private var numberButtons: [[Int]] = {
        var buttons: [[Int]] = []
        for _ in 0..<5 {
            var row: [Int] = []
            for _ in 0..<5 {
                row.append(Int.random(in: 1...15))
            }
            buttons.append(row)
        }
        return buttons
    }()
    
    var body: some View{
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text("\(targetNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                ForEach(0..<5) { row in
                    HStack {
                        ForEach(0..<5) { column in
                            let numberButton = numberButtons[row][column]
                            
                            Button(action: {
                                if !isButtonSelected(row: row, column: column) {
                                    selectedButtons.append((row, column))
                                    allSelectedButtons.append(numberButtons[row][column])
                                    
                                    if sumSelectedNumber(allSelectedButtons) == targetNumber {
                                        selectedButtonsAndEqualTarget += selectedButtons
                                        selectedButtons.removeAll()
                                        arrayAllNumber = arrayAllNumber.filter { !allSelectedButtons.contains($0) }
                                        allSelectedButtons.removeAll()
                                    }
                                    else if sumSelectedNumber(allSelectedButtons) > targetNumber{
                                        selectedButtons.removeAll()
                                        allSelectedButtons.removeAll()
                                    }
                                }
                                if isContainsTuple(selectedButtonsAndEqualTarget, (row, column)){
                                    targetNumber = updateTargetNumber(arr: arrayAllNumber)
                                }
                            }) {
                                Text("\(numberButton)")
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Group{
                                        if isButtonSelected(row: row, column: column) {
                                            Color.green
                                        }
                                        else if isContainsTuple(selectedButtonsAndEqualTarget, (row, column)){
                                            Color.white
                                        }
                                        else {
                                            Color.blue
                                        }})
                                    .opacity(!isContainsTuple(selectedButtonsAndEqualTarget, (row, column)) ? 1 : 0)
                                    .animation(.easeInOut(duration: isButtonSelected(row: row, column: column) ? 0.3 : 3.0 ))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                //Text("\(sumSelectedNumber(allSelectedButtons))")
                
                Button(action: {
                    resetGame()
                }) {
                    Text("Reset")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .onAppear{
                resetGame()
            }
        }
        .ignoresSafeArea()
    }
    private func isButtonSelected(row: Int, column: Int) -> Bool {
        return selectedButtons.contains { $0.row == row && $0.column == column }
    }
    
    func sumSelectedNumber (_ array: [Int]) -> Int{
        var sum = 0
        for i in array {
            sum += i
        }
        return sum
    }
    
    func isContainsTuple<T: Equatable>(_ array: [(T, T)], _ tuple: (T, T)) -> Bool {
        return array.contains(where: { $0 == tuple })
    }
    
    func twoDArrayToOneDArray (arr: [[Int]]) -> [Int] {
        
        var oneDimensionArray:[Int] = []
        
        for row in arr {
            for element in row {
                oneDimensionArray.append(element)
            }
        }
        
        return oneDimensionArray
    }
    
    func updateTargetNumber(arr: [Int]) -> Int{
        var sum = 0
        
        if arr.count > 20 {
            for _ in 1...4 {
                sum += arr.randomElement() ?? 0
            }
        }
        else if arr.count > 5{
            for _ in 1...3{
                sum += arr.randomElement() ?? 0
            }
        }
        else {
            sum = (arr.randomElement() ?? 0) + (arr.randomElement() ?? 0)
        }
        
        return sum
    }
//
//    func generateNumberButtons() {
//        var buttons: [[Int]] = []
//        for _ in 0..<5 {
//            var row: [Int] = []
//            for _ in 0..<5 {
//                row.append(Int.random(in: 1...15))
//            }
//            buttons.append(row)
//        }
//        numberButtons = buttons
//    }
//
    func resetGame() {
        selectedButtons.removeAll()
        selectedButtonsAndEqualTarget.removeAll()
        allSelectedButtons.removeAll()
        arrayAllNumber = twoDArrayToOneDArray(arr: numberButtons)
        targetNumber = Int.random(in: 20...40)
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
