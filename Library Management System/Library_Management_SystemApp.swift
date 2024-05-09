//
//  Library_Management_SystemApp.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 22/04/24.
//

import SwiftUI
import Firebase
import TipKit
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct Library_Management_SystemApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var LibModel = LibrarianViewModel()
    @AppStorage("emailLoggedIn") var emailLoggedIn = "false"
    @AppStorage("signIn") var isSignIn = "false"

    
    // Admin side parameters
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var staffViewModel = StaffViewModel()
    @StateObject var userAuthViewModel = AuthViewModel()
    @StateObject var configViewModel = ConfigViewModel()
    @StateObject var memModelView = UserBooksModel()
    
    @StateObject var confiModel = ConfigViewModel()
    @StateObject var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            if emailLoggedIn == "user" {
                Membership(memModelView: memModelView, ConfiViewModel: configViewModel, LibViewModel: LibViewModel, authViewModel: userAuthViewModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                        }
                    }
            }
            else if emailLoggedIn == "admin" {
                AdminTabView(LibViewModel: LibViewModel, staffViewModel: staffViewModel, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                        }
                    }
            }
            else if emailLoggedIn == "librarian" {
                LibrarianFirstScreenView(LibModelView: LibModel, ConfiViewModel: confiModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                        }
                    }
            }
            else if emailLoggedIn == "member" {
                MemberTabView(memModelView: memModelView, ConfiViewModel: configViewModel, LibViewModel: LibViewModel, authViewModel: userAuthViewModel)
                    .transition(.move(edge: .leading))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                        }
                    }
            }
            else {
                ContentView()
                    .transition(.move(edge: .trailing))
                    .environmentObject(themeManager)
                    .task {
                        do{
                            await themeManager.setBaseTheme()
                        }
                    }
            }
        }
    }
    init(){
        FirebaseApp.configure()
        try? Tips.configure()
    }
}
