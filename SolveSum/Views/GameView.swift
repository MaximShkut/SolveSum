//
//  GameView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI

struct StartGame: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View{
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 10) {
                GeometryReader { geometry in
                    HStack {
                        VStack {
                            Text("Score")
                            Text("\(viewModel.score)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.2)
                        }
                        
                        Text("\(viewModel.targetNumber)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(width: geometry.size.width * 0.5)
                        
                        Button(action: {
                            viewModel.showHint()
                        }, label: {
                            Image(systemName: "lightbulb")
                                .font(.title)
                                .foregroundColor(.yellow)
                        })
                        .padding(8)
                        .background(.indigo)
                        .clipShape(Circle())
                        .frame(width: geometry.size.width * 0.20)
                    }
                    .padding()
                }
                .frame(height: 70)
                
                ForEach(0..<viewModel.gameConfiguration.boardSize, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<viewModel.gameConfiguration.boardSize, id: \.self) { column in
                            if let cell = viewModel.getCell(row: row, column: column){
                                if !cell.isDeleted{
                                    Button(action: {
                                        if let index = viewModel.cells.firstIndex(of: cell){
                                            viewModel.cells[index].isSelected.toggle()
                                            viewModel.checkProgress()
                                        }
                                    }, label: {
                                        Text("\(cell.value)")
                                    })
                                    .frame(width: viewModel.cellSize, height: viewModel.cellSize)
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
                                        .frame(width: viewModel.cellSize, height: viewModel.cellSize)
                                        .opacity(0)
                                }
                            }
                        }
                    }
                }
                HStack{
                    Button(action: {
                        viewModel.startGame()
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
//                    Button(action: {
//                        viewModel.addButtonTapped()
//                    }, label: {
//                        Text("Add Button")
//                    })
//                    .font(.headline)
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.green)
//                    .cornerRadius(10)
                }
            }
            .onAppear{
                viewModel.startGame()
            }
        }
        .ignoresSafeArea()
    }
}
