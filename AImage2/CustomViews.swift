//
//  AImage2App.swift
//  AImage2
//
//  Created by Astrid Lanz on 17.12.2023.
//  refactored Version after Crash

import Foundation
import SwiftUI

// make LogoView reusable in all views
struct LogoView: View {
    var body: some View {
        HStack {
            Image("aperture")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)

            Text("A")
                .foregroundColor(.blue)
            + Text("I")
                .foregroundColor(.green)
            + Text("mage")
                .foregroundColor(.black)
        }
        .font(.title)
    }
}

// have consistent Buttonstyle within the App
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8) // Control the size of the button
            .background(Color.blue) // Set the background color
            .foregroundColor(.black) // Set the text color
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1) // Border
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Slightly shrink when pressed
    }
}

