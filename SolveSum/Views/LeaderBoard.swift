//
//  LeaderBoard.swift
//  SolveSum
//
//  Created by user236450 on 8/1/23.
//

import SwiftUI

struct LeaderBoard: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mint.opacity(0.4)
                    .ignoresSafeArea()
                
                List(dataManager.users, id: \.id) { user in
                    HStack {
                        Text(user.nickname)
                        Text("\(user.score)")
                    }
                }
                .navigationTitle("Leader Board")
            }
        }
    }
}

struct LeaderBoard_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoard()
    }
}
