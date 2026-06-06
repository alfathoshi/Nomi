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
    private var isFormComplete: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedAge != nil &&
        selectedAvatar != nil &&
        selectedGender != nil
    }

    private var profileProgress: Double {
        var completed = 0

        if selectedAvatar != nil { completed += 1 }
        if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { completed += 1 }
        if selectedAge != nil { completed += 1 }
        if selectedGender != nil { completed += 1 }

        return Double(completed) / 4.0
    }

    private var completedProfileSteps: Int {
        var completed = 0

        if selectedAvatar != nil { completed += 1 }
        if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { completed += 1 }
        if selectedAge != nil { completed += 1 }
        if selectedGender != nil { completed += 1 }

        return min(max(completed, 1), 4)
    }
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading) {
                Text("Step \(completedProfileSteps) of 4")
                    .font(.label(weight: .regular))
                
                ProgressBar(height: 12, progress: profileProgress)
                    .animation(.spring(response: 0.45, dampingFraction: 0.8), value: profileProgress)
                    .padding(.bottom, 20)
                
                
                Divider()
                    .padding(.horizontal, -20)
                    .padding(.bottom, 20)
                
                Text("Who is your child? 😊")
                    .font(.heading2(weight: .bold))
                
                Text("Pick an avatar and tell us your child's name")
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
                
                Text("WHAT'S YOUR CHILD'S NAME?")
                    .font(.label())
                    .foregroundColor(.textSecondary)
                
                TextField("Your child's name", text: $name)
                    .font(.bodyLarge())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray.opacity(0.2),
                                    lineWidth: 1.5)
                    )
                    .padding(.bottom, 20)
                
                Text("HOW OLD IS YOUR CHILD?")
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
                
                
                Text("THEY ARE A ...")
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
                .disabled(!isFormComplete)
                .opacity(isFormComplete ? 1 : 0.5)
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
            .navigationTitle("Set up Your Child's Profile")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileSetupView()
}
