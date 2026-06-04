//
//  ProfileSetupView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI

struct ProfileSetupView: View {
    @State private var name = ""
    @State private var selectedAge: Int? = nil
    @State private var selectedAvatar: String? = nil
    @State private var selectedGender: String? = nil
    @State private var goToHomeScreen: Bool = false
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading) {
                Text("Step 1 of 2")
                    .font(.label(weight: .regular))
                
                ProgressBar(height: 12, progress: 0.5)
                .padding(.bottom, 20)
                
                
                Divider()
                    .padding(.horizontal, -20)
                    .padding(.bottom, 20)
                
                Text("Who are you? 😊")
                    .font(.heading2(weight: .bold))
                
                Text("Pick an avatar and tell us your name")
                    .font(.bodySmall(weight: .regular))
                    .padding(.bottom, 20)
                    .foregroundColor(.textSecondary)
                
                HStack(spacing: 25) {
                    AvatarButton(avatar: "👧", selectedAvatar: $selectedAvatar)
                    AvatarButton(avatar: "👦", selectedAvatar: $selectedAvatar)
                    AvatarButton(avatar: "👩", selectedAvatar: $selectedAvatar)
                    AvatarButton(avatar: "🧑", selectedAvatar: $selectedAvatar)
                }
                .padding(.bottom, 20)
                
                Text("WHAT'S YOUR NAME?")
                    .font(.label())
                    .foregroundColor(.textSecondary)
                
                TextField("Your name", text: $name)
                    .font(.bodyLarge())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray.opacity(0.2),
                                    lineWidth: 1.5)
                    )
                    .padding(.bottom, 20)
                
                Text("HOW OLD ARE YOU?")
                    .font(.label())
                    .foregroundColor(.textSecondary)
                
                HStack (spacing: 14){
                    ForEach(6...9, id: \.self) { age in
                        AgeButton(
                            age: age,
                            selectedAge: $selectedAge
                        )
                    }
                    
                }
                .padding(.bottom, 20)
                
                
                Text("I AM A ...")
                    .font(.label())
                    .foregroundColor(.textSecondary)
                
                HStack (spacing: 14){
                    GenderButton(
                        title: "Girl 👧",
                        selectedGender: $selectedGender)
                    GenderButton(
                        title: "Boy 👦",
                        selectedGender: $selectedGender)
                    GenderButton(
                        title: "Other 🧒",
                        selectedGender: $selectedGender)
                }
                .padding(.bottom, 20)
                Spacer()
                WideButton(
                    title: "Continue",
                    icon: "arrow.forward")
                {
                    goToHomeScreen = true
                }
                .navigationDestination(isPresented: $goToHomeScreen) {
                    HomeScreen()
                }
            }
            
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle("Set up Your Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileSetupView()
}
