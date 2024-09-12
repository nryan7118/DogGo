//
//  OnboardingPageView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/10/24.
//

import SwiftUI

struct OnboardingPageView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.onBoardingBG)
    }
}

#Preview {
    OnboardingPageView(imageName: "logo", title: "Welcome to DogGo", description: "A place for you and your best friend.")
}
