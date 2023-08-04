//
//  DataManager.swift
//  SolveSum
//
//  Created by user236450 on 8/1/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class DataManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func fetchUsers() {
        users.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("users")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let nickname = data["nickname"] as? String ?? ""
                    let score = data["score"] as? Int ?? 0
                    
                    let user = User(id: id, nickname: nickname, score: score)
                    self.users.append(user)
                }
            }
        }
    }
    
    func addNewUser(nickname: String, id: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        
        // Проверяем, существует ли пользователь с таким никнеймом
        ref.whereField("nickname", isEqualTo: nickname).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching users:", error)
                return
            }
            
            if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                // Пользователь с таким никнеймом уже существует
                print("User with nickname '\(nickname)' already exists.")
                // Выполните здесь код для отображения уведомления или других действий при существующем пользователе с таким никнеймом.
            } else {
                // Пользователя с таким никнеймом нет, добавляем нового пользователя
                let newUser: [String: Any] = [
                    "id": id,
                    "nickname": nickname,
                    "score": 0
                ]
                
                ref.addDocument(data: newUser) { error in
                    if let error = error {
                        print("Error adding new user:", error)
                    } else {
                        print("New user added successfully.")
                    }
                }
                let newwUser = User(id: id, nickname: nickname, score: 0)
                self.currentUser = newwUser
            }
        }
    }
    
    func updateScore(userNickname: String, newScore: Int) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        fetchUsers()
        // Проверяем, есть ли пользователь с указанным никнеймом в базе данных
        usersRef.whereField("nickname", isEqualTo: userNickname).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Ошибка при запросе пользователей:", error.localizedDescription)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("Пользователь с никнеймом '\(userNickname)' не найден в базе данных.")
                // Выполните здесь код для обработки ситуации, когда пользователя не найдено.
                return
            }
            
            // Обновляем очки у найденного пользователя
            if let userDocument = documents.first {
                let userRef = usersRef.document(userDocument.documentID)
                userRef.updateData(["score": newScore]) { error in
                    if let error = error {
                        print("Ошибка при обновлении очков:", error.localizedDescription)
                    } else {
                        print("Очки успешно обновлены!")
                    }
                }
            }
        }
    }

}
