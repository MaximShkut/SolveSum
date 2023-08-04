//
//  UserSettingsView.swift
//  SolveSum
//
//  Created by user236450 on 8/3/23.
//

import SwiftUI
import FirebaseFirestore

struct UserSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var isShowAlert = false
    @State private var nickname = ""
    
    var body: some View {
        ZStack {
            Color.mint.opacity(0.4)
                .ignoresSafeArea()
            VStack {
                TextField("Nickname", text: $nickname)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                
                Button(action: {
                    guard !nickname.isEmpty else {
                           print("Nickname is empty.")
                           return
                       }
                       var userExists = false // Добавьте флаг для проверки существования пользователя с таким никнеймом
                       for user in dataManager.users {
                           if user.nickname == nickname {
                               userExists = true
                               break
                           }
                       }
                       
                       if !userExists {
                           dataManager.addNewUser(nickname: self.nickname, id: UIDevice.current.identifierForVendor!.uuidString)
                           dismiss()
                       } else {
                           isShowAlert.toggle() // Показываем уведомление, если пользователь с таким никнеймом уже существует
                       }
                }) {
                    Text("Apply")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
                }
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Ok")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
                })
                
            }
        }
        .alert(isPresented: $isShowAlert, content: {
            Alert(title: Text("This nickname already exists"), message: Text("Choose a new nickname"), dismissButton: .default(Text("OK"), action: {
                isShowAlert.toggle()
            }))
        })
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
