//
//  ContentView.swift
//  shruk_application
//
//  Created by Yahor Hreben on 25.06.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: CellViewModel = CellViewModel()
    @State var imageSize: CGFloat = 50
    @State var animationAmount: CGFloat = 0
    @Namespace var animation
    var body: some View {
        ZStack {
            Color(uiColor: UIColor(red: 0.4196, green: 0.4196, blue: 0.4196, alpha: 1.0)).ignoresSafeArea()
            VStack {
                Text("\(vm.goalNumber)")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                
                VStack(spacing: 8) {
                    ForEach(0..<vm.sizeOfTable) { row in
                        HStack(spacing: 8){
                            ForEach(0..<vm.sizeOfTable) {column in
                                if let cell = vm.getCell(row: row, column: column) {
                                    cellView(cell: cell)
                                        .frame(width: vm.sizeOfCell, height: vm.sizeOfCell)
                                        .offset(y: cell.offsetY)
                                    //.matchedGeometryEffect(id: cell.id, in: animation)
                                }
                            }
                        }
                        
                    }
                }
                .padding(16)
                .background(Color(uiColor: UIColor(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1.0)))
                .cornerRadius(12)
                .shadow(radius: 10)
                
                Button(action: {
                    vm.addNewCell()
                }, label: {
                    Text("Add new Cell")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(vm.cells.filter{ $0.isDeleted}.count == 0 ? .white.opacity(0.7) : .white)
                        .font(.title2)
                        .padding(.vertical)
                })
                .frame(maxWidth: .infinity)
                .disabled(vm.cells.filter{ $0.isDeleted}.count == 0)
                .background(vm.cells.filter{ $0.isDeleted}.count == 0 ? Color.pink.opacity(0.7) : Color.pink)
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.horizontal, 8)
            }
        }
        .overlay(
            Image(systemName: "questionmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .background(Color(uiColor: UIColor(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1.0)).clipShape(Circle()))
                .shadow(radius: 5)
                .frame(width: imageSize, height: imageSize)
                .padding()
                
                .overlay(
                    Circle ()
                        .stroke(Color(uiColor: UIColor(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1.0)))
                        .scaleEffect (animationAmount)
                        .opacity(2 - animationAmount)
                        .animation (
                            .easeInOut (duration: 1)
                            .repeat(while: animationAmount != 0),
                            value: animationAmount
                        )
                )
                .onTapGesture {
                    vm.clickHelp()
                    animationAmount = 0
                }
            , alignment: .topTrailing
        )
        .onAppear {
            vm.loadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                animationAmount = 2
            }
        }
    }
    
    @ViewBuilder
    func cellView(cell: CellModel) -> some View {
        if cell.isDeleted {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(cell.isClicked ? Color.pink.opacity(0.8) : Color.pink)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    Text("\(cell.number)")
                        .bold()
                        .font(.title3)
                )
                .overlay(
                    border(flag: cell.isClicked || cell.isHelp)
                )
                .onTapGesture {
                    vm.clickOnCell(cell: cell)
                }
        }
    }
    
    @ViewBuilder
    func border(flag: Bool) -> some View {
        if flag {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.yellow, lineWidth: 2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Animation {
    func `repeat`(while expression: Bool) -> Animation {
        if expression {
            return self.repeatCount(3, autoreverses: false)
        } else {
            return self
        }
    }
}
