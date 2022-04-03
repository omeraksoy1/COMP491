//
//  LoginView.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 25.03.2022.
//

import SwiftUI
import ActivityIndicatorView
import AlertToast
import FirebaseAuth


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginProcess = false
    @State private var loginSuccess = false
    @State private var isButtonHidden = false
    @State private var showLoadingIndicator = false
    @State private var showAlert = false
    @State private var alert = AlertToast(type: .error(.red), title: "Wrong entry")
    
    var body: some View {
        VStack (spacing: 15) {
            Spacer()
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                TextField("Email",text: $email)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .disableAutocorrection(true)
            }.frame(width: 300, height: 40, alignment: .center)
                .border(.gray, width: 0.3)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                SecureField("Password",text: $password)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
            }.frame(width: 300, height: 40, alignment: .center)
                .cornerRadius(8)
                .border(.gray, width: 0.3)
            
            ActivityIndicatorView(isVisible: self.$showLoadingIndicator, type: .rotatingDots)
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
            Button(action: {
                self.isButtonHidden = true
                self.showLoadingIndicator = true
                signInUser(userEmail: email, userPassword: password)
            }) {
                Text("Login")
                    .foregroundColor(.white)
            }.frame(width: 300, height: isButtonHidden ? 0 : 40 , alignment: .center)
                .background(!email.isEmpty && !password.isEmpty ? .green.opacity(0.7) : .gray)
                .cornerRadius(8)
                .disabled(!loginProcess && !email.isEmpty && !password.isEmpty ? false : true)
            Spacer()
            
            HStack{
                Text("Don't have an account?")
            
                NavigationLink("Sign up", destination: SignUpView())
                    .foregroundColor(.blue)
            }
            
        }.frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden(true)
            .toast(isPresenting: $showAlert, duration: 2) {
                alert
            }
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        loginProcess = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.showLoadingIndicator = false
            guard error == nil else {
                self.showAlert = true
                self.loginProcess = false
                self.isButtonHidden = false
                return
            }
            
            switch authResult {
            case .none:
                loginProcess = false
                loginSuccess = false
            case .some(_):
                loginProcess = false
                loginSuccess = true
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
