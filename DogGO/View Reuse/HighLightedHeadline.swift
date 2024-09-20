//
//  ViewTextRow.swift
//  DogGO
//
//  Created by Nick Ryan on 9/3/24.
//

import SwiftUI

struct HighLightedHeadline: View {
    var value: String
    var imageString: String?

    let shadowRadius: CGFloat = 2.0
    let frameLength: CGFloat = 50.0
    
    var body: some View {
            HStack {
                Text(value)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .fontWidth(.expanded)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal)
                    .shadow(color: .black, radius: shadowRadius)
                Spacer()
                Image(imageString ?? "")
                    .resizable()
                    .frame(maxWidth: frameLength, maxHeight: frameLength)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray)
    }
}

#Preview {
    HighLightedHeadline(value: "Kobe", imageString: "collarPhoto")
}
