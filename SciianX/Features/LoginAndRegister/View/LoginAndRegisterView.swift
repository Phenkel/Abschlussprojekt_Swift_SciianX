import SwiftUI

struct LoginAndRegisterView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var isLogin = true
    @State private var email = "philipphnkl@proton.me"
    @State private var password = "Ezio130697"
    @State private var passwordConfirm = "Ezio130697"
    @State private var realName = "Philipp Henkel"
    @State private var userName = "philipphnkl"
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundImage()
                
                VStack(spacing: 16) {
                    Image("app-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 32)
                    
                    Picker(selection: $isLogin.animation(), label: Text("Login/Register")) {
                        Text("Login_Key").tag(true)
                        Text("Register_Key").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Group {
                        HStack {
                            Image(systemName: "envelope.fill")
                            TextField("Email_Key", text: $email)
                                .keyboardType(.emailAddress)
                        }
                        HStack {
                            Image(systemName: "eye.slash.fill")
                            SecureField("Password_Key", text: $password)
                        }
                        if !isLogin {
                            HStack {
                                Image(systemName: "eye.slash.fill")
                                SecureField("PasswordConfirm_Key", text: $passwordConfirm)
                            }
                            HStack {
                                Image(systemName: "person.fill")
                                TextField("Real Name", text: $realName)
                                    .keyboardType(.emailAddress)
                            }
                            HStack {
                                Image(systemName: "person.fill")
                                TextField("Username", text: $userName)
                                    .keyboardType(.emailAddress)
                            }
                        }
                    }
                    .padding(12)
                    .background(.bar)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button(action: {
                        if isLogin {
                            withAnimation {
                                authenticationViewModel.login(mail: self.email, password: self.password)
                            }
                        } else {
                            withAnimation {
                                authenticationViewModel.register(
                                    mail: self.email,
                                    password: self.password,
                                    passwordConfirm: self.passwordConfirm,
                                    realName: self.realName,
                                    userName: self.userName
                                )
                            }
                        }
                    }, label: {
                        HStack {
                            Spacer()
                            Text(isLogin ? "Login_Key" : "Register_Key")
                                .foregroundStyle(.white)
                                .padding(8)
                            Spacer()
                        }
                    })
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if !authenticationViewModel.errorMessage.isEmpty {
                        Text(authenticationViewModel.errorMessage)
                            .font(.footnote)
                            .fontWidth(.compressed)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
            }
        }
    }
}

