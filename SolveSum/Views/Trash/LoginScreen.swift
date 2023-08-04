////
////  LoginScreen.swift
////  SolveSum
////
////  Created by user236450 on 8/1/23.
////
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//struct LoginScreen: View {
//    @EnvironmentObject var dataManager: DataManager
//    @State private var email = ""
//    @State private var password = ""
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var isUserRegistered = false
//    @State private var isUserLogged = false
//    @State private var message = ""
//
//    var body: some View {
//        if isUserRegistered {
//            userRegistration
//        } else {
//            userAuthorization
//        }
//    }
//
//    var userAuthorization: some View {
//        NavigationView {
//            ZStack {
//                Color.mint.opacity(0.4)
//                    .ignoresSafeArea()
//
//                VStack(spacing: 20) {
//                    TextField("Email", text: $email)
//                        .keyboardType(.emailAddress)
//                        .textInputAutocapitalization(.never)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
//
//                    SecureField("Password", text: $password)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
//
//                    Button(action: {
//                        login()
//                    }) {
//                        Text("Sign in")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
//                    }
//
//                    Button(action: {
//                        isUserRegistered.toggle() // Переключаем значение isUserRegistered при нажатии на кнопку
//                    }) {
//                        Text("Don't have an account? Register")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
//                    }
//
//                    Text(self.message)
//                        .foregroundColor(.black)
//                }
//                .padding()
//            }
//        }
//        .toolbar(.hidden)
//        .fullScreenCover(isPresented: $isUserLogged, content: {
//            StartView()
//        })
//    }
//
//    var userRegistration: some View {
//        NavigationView {
//            ZStack {
//                Color.mint.opacity(0.4)
//                    .ignoresSafeArea()
//
//                VStack(spacing: 20) {
//                    TextField("First Name", text: $firstName)
//                        .textInputAutocapitalization(.words)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
//
//                    TextField("Last Name", text: $lastName)
//                        .textInputAutocapitalization(.words)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
//
//                    TextField("Email", text: $email)
//                        .keyboardType(.emailAddress)
//                        .textInputAutocapitalization(.never)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
//
//                    SecureField("Password", text: $password)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
//
//                    Button(action: {
//                        register()
//                    }) {
//                        Text("Sign up")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
//                    }
//
//
//                    Button(action: {
//                        isUserRegistered.toggle()
//                    }) {
//                        Text("Already have an account? Login")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
//                    }
//                    Text(self.message)
//                        .foregroundColor(.black)
//                }
//                .padding()
//            }
//        }
//        .toolbar(.hidden)
//        .fullScreenCover(isPresented: $isUserLogged, content: {
//            StartView()
//        })
//
//    }
//
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("Failed to login user:", error)
//                self.message = "Failed to login user: \(error)"
//                return
//            } else {
//                print("Successfully logged in as user: \(result?.user.uid ?? "")")
//
//                self.message = "Successfully logged in as user: \(result?.user.uid ?? "")"
//
//                isUserLogged.toggle()
//
//                dataManager.currenUser = User(id: result?.user.uid ?? "", firstName: "", lastName: "", email: email, score: 0)
//            }
//        }
//    }
//
//    func register() {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("Failed to create user:", error)
//                self.message = "Failed to create user: \(error)"
//                return
//            } else {
//                print("Successfully created user: \(result?.user.uid ?? "")")
//
//                self.message = "Successfully created user: \(result?.user.uid ?? "")"
//
//                self.storeUserInformation()
//                isUserLogged.toggle()
//
//                dataManager.currenUser = User(id: result?.user.uid ?? "", firstName: "", lastName: "", email: email, score: 0)
//            }
//
//        }
//    }
//
//    func storeUserInformation() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let userData = ["firstName": self.firstName, "lastName": self.lastName, "email": self.email, "uid": uid, ]
//        Firestore.firestore().collection("users")
//            .document(uid).setData(userData) { error in
//                if let error = error {
//                    print(error)
//                    self.message = "\(error)"
//                    return
//                }
//
//                print("Success")
//            }
//    }
//}
//
//struct LoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginScreen()
//    }
//}
