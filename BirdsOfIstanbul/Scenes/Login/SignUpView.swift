//
//  SignUpView.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 27.03.2022.
//

import SwiftUI
import ActivityIndicatorView
import AlertToast
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var signupProcess = false
    @State private var signupSuccess = false
    @State private var isButtonHidden = false
    @State private var showLoadingIndicator = false
    @State private var showAlert = false
    @State private var alert = AlertToast(type: .error(.red), title: "Unable to create account")
    
    var body: some View {
        VStack (spacing: 15) {
            
            Image("iconBird")
                .resizable()
                .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, minHeight: 100, idealHeight: 150, maxHeight: 200, alignment: .center)
                .padding(.all)
            
            Text("Birds Of Istanbul")
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .padding(.bottom)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                TextField("Email",text: $email)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
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
                signUpUser(userEmail: email, userPassword: password)
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
            }.frame(width: 300, height: isButtonHidden ? 0 : 40 , alignment: .center)
                .background(!email.isEmpty && !password.isEmpty ? .green.opacity(0.7) : .gray)
                .cornerRadius(8)
                .disabled(!signupProcess && !email.isEmpty && !password.isEmpty ? false : true)
            
            
            /*NavigationLink(destination: WalkthroughUIViewController().navigationBarBackButtonHidden(true), isActive: $signupSuccess) {
            }.disabled(signupSuccess)*/
            
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                NavigationLink("Sign in", destination: LoginView())
                    .foregroundColor(.blue)
                    .animation(.none, value: 0)
            }
            
        }.frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden(true)
            .toast(isPresenting: $showAlert, duration: 2) {
                alert
            }
    }
    
    func signUpUser(userEmail: String, userPassword: String) {
        signupProcess = true
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.showLoadingIndicator = false
            guard error == nil else {
                self.showAlert = true
                self.signupProcess = false
                self.isButtonHidden = false
                return
            }
            
            switch authResult {
                case .none:
                    signupProcess = false
                    signupSuccess = false
                case .some(_):
                    signupProcess = false
                    signupSuccess = true
            }
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
