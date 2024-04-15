//
//  SciianXApp.swift
//  SciianX
//
//  Created by Philipp Henkel on 10.01.24.
//

import SwiftUI
import FirebaseCore
import StreamChat
import StreamChatSwiftUI

@main
struct SciianXApp: App {
    
    @StateObject var authenticationViewModel = AuthenticationViewModel(authenticationRepository: FirebaseAuthenticationRepository.shared, mailCheckRepository: ApiMailCheckRepository.shared)
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authenticationViewModel.user != nil {
                ContentView(self.authenticationViewModel)
                    .environmentObject(self.authenticationViewModel)
            } else {
                LoginAndRegisterView()
                    .environmentObject(self.authenticationViewModel)
            }
        }
    }
}
