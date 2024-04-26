//
//  LoginView.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    private var db = Firestore.firestore()
    @StateObject private var viewModel = AuthViewModel()
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewMOdel = ConfigViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var shouldNavigate: Bool = false
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack {
                    
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 300, height: 150, alignment: .center)
                    
                    Text("Log In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                        .padding(.top)
                    
                    HStack{
                        Spacer()
                        
                        Text("*All fields are mandatory")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                    }
                    
                    TextField("Email Id", text: $email)
                        .font(.title3)
                        .padding(12)
                        .autocapitalization(.none)
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    SecureField("Password", text: $password)
                        .font(.title3)
                        .padding(12)
                        .autocapitalization(.none)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    Button {
                        Task{
                            try? await resetPassword(email: email)
                        }
                    } label: {
                        Text("Forgot your password?")
                            .font(.caption)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                    
                    Button(action: {
                        
                        print("Login Aettmpt")
                        viewModel.login(email: email, password: password)
                        print($viewModel.shouldNavigateToAdmin)
                        
                    }) {
                        Text("Log In")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("PrimaryColor"))
                            .cornerRadius(50)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    NavigationLink(destination: AdminTabView(), isActive: $viewModel.shouldNavigateToAdmin) { EmptyView() }
                    NavigationLink(destination: LibrarianFirstScreenView(LibModelView: LibViewModel, ConfiViewModel: ConfiViewMOdel), isActive: $viewModel.shouldNavigateToLibrarian) { EmptyView() }
                    NavigationLink(destination: MemberTabView(), isActive: $viewModel.shouldNavigateToMember) { EmptyView() }
                    NavigationLink(destination: Membership(), isActive: $viewModel.shouldNavigateToGeneral) { EmptyView() }
                    
                    
                }.padding()
                
                Spacer()
                
                HStack{
                    Text("Don't have an account?")
                    NavigationLink(destination: SignupView()){
                        Text("REGISTER NOW")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                .padding([.leading, .trailing, .top])
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .task {
                    LibViewModel.getBooks()
                }
                
            }
        }
    }
    // function to reset the password
    func resetPassword(email: String) async throws {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Password updated")
            } catch let error as NSError {
                print("error")
                throw error
            }
        }
}

#Preview {
    LoginView()
}


