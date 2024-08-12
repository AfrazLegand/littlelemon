//
//  UserProfileView.swift
//  LittleLemon
//
//  Created by Afraz Siddiqui on 11/08/2024.
//

import SwiftUI

struct UserProfileView: View {
    private let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    private let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    private let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Personal Information")
                .font(.title)
                .padding()
            
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
            
            Text("First Name: \(firstName)")
                .padding(.bottom, 5)
            Text("Last Name: \(lastName)")
                .padding(.bottom, 5)
            Text("Email: \(email)")
            
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    UserProfileView()
}
