//
//  GameView.swift
//  SolveSum
//
//  Created by user236450 on 7/3/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    @State private var isTimerStart: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var countDowntimer = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
            Color.mint.opacity(0.4)
                .ignoresSafeArea()
            
            if viewModel.gameConfiguration.countDownTimer > 0 {
                VStack{
                    LinearGradient(
                        colors: [.white, .clear, .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .mask(
                        Text("\(viewModel.formattedTime(viewModel.gameConfiguration.countDownTimer))")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 300) 
                            .offset(y: +200)
                    )
                }
            }
            
            Spacer()
            VStack(spacing: 10) {
                HStack {
                    VStack {
                        Text("Score")
                        Text("\(viewModel.score)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width:UIScreen.width / 3)
                    }
                    
                    Text("\(viewModel.targetNumber)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width:UIScreen.width / 3)
                    
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
                    .frame(width:UIScreen.width / 3)
                }
                .padding()
                
                ForEach(0..<viewModel.gameConfiguration.boardSize, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<viewModel.gameConfiguration.boardSize, id: \.self) { column in
                            if let cell = viewModel.getCell(row: row, column: column) {
                                if !cell.isDeleted {
                                    Button(action: {
                                        if let index = viewModel.cells.firstIndex(of: cell){
                                            viewModel.cells[index].isSelected.toggle()
                                            viewModel.checkProgress()
                                        }
                                    }, label: {
                                        Text("\(cell.value)")
                                            .frame(width: viewModel.cellSize, height: viewModel.cellSize)
                                    })
                                    
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
                                    .opacity(cell.cellOpacity)
                                    .offset(y: cell.offset)
                                }
                                else {
                                    Rectangle()
                                        .frame(width: viewModel.cellSize, height: viewModel.cellSize)
                                        .opacity(0)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear{
            viewModel.startGame()
            isTimerStart = true
            countDowntimer = viewModel.gameConfiguration.countDownTimer
        }
        .onReceive(timer){ _ in
            if viewModel.gameConfiguration.countDownTimer > 0 && isTimerStart{
                viewModel.gameConfiguration.countDownTimer -= 1
            } else {
                isTimerStart = false
                isShowingAlert = true
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
