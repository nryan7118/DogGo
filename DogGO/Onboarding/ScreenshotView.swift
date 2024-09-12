//
//  ScreenshotView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/11/24.
//

import SwiftUI

struct ScreenshotView: View {
    var imageName: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(index == 0 ? .white : .gray)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ScreenshotView(imageName: "gettingStartedOnboarding")
}
