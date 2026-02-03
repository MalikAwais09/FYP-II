//
//  Login.swift
//  Exam Proctoring
//
//  Created by Malik Awais on 3/2/2026.
//

import SwiftUI

    struct Login: View {
    //@AppStorage("login") private var isLogin = false
    @State var isLogin = false

    @State private var showTitle = false
    @State private var showShield = false
    @State private var showCircle = false
    @State private var showButton = false
    @State private var navigate = false
    @State private var aridNo : String = ""
        @State private var showAlert : Bool = false
        
    @Binding var isLoggedIn: Bool

    var body: some View {
            VStack(spacing: 40) {
                Text("PROCTOR EXAM")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : -30)
                
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 55))
                    .foregroundColor(.blue)
                    .scaleEffect(showShield ? 1 : 0.5)
                    .opacity(showShield ? 1 : 0)
                
                
                ZStack {
                    Image("Login Face") // Your circular face image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .scaleEffect(showCircle ? 1 : 0.8)
                        .opacity(showCircle ? 1 : 0)
                }
                
                TextField(text: $aridNo, label: {
                    Text("Enter your Arid Number")
                })
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                })
                .padding(.horizontal, 15)
                
                Spacer()
                
                Button(action: {
                    // Face ID action here
                    if aridNo.isEmpty{
                     showAlert = true
                    }
                    else {
                        isLoggedIn = true
                        isLogin = true
                    }
                    
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "faceid")
                            .font(.system(size: 22))
                        Text("Login with Face ID")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .shadow(radius: 3)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(showButton ? 1 : 0)
                .offset(y: showButton ? 0 : 40)
            }
            .fullScreenCover(isPresented: $isLogin, content: {
                StudentDashboard(ID: 1, U_ID: 1, name: "Awais")
                    .navigationBarBackButtonHidden(true)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear {
                startAnimations()
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Please enter the arid number to proceed."))
            })
    }
        

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            showTitle = true
        }

        withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
            showShield = true
        }

        withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
            showCircle = true
        }

        withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
            showButton = true
        }
    }
    }

#Preview {
    Login(isLoggedIn: .constant(false))
}
