//
//  AImageApp.swift
//  AImage
//
//  Created by Astrid Lanz on 17.12.2023.
//

import SwiftUI
import Replicate

// https://replicate.com/stability-ai/stable-diffusion
enum StableDiffusion: Predictable {
  static var modelID = "stability-ai/stable-diffusion"
  static let versionID = "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf"

  struct Input: Codable {
      let prompt: String
  }

  typealias Output = [URL]
}


struct ImageSearchView: View {
    @State private var prompt: String = ""
    @State private var imageURL: URL?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var client: Replicate.Client?
    @EnvironmentObject var userManager: UserManager


    var body: some View {
        VStack(spacing: 0) {
            LogoView()
                .padding(.top, 10)
            
            ScrollView {
                VStack {
                    
                    Spacer(minLength: 50)
                    
                    if !isLoading && imageURL == nil {
                        textEditor
                        generateButton
                    }
                    
                    
                    
                    loadingOrImage
                    
                    if imageURL != nil {
                        newSearchButton
                    }
                   
                    errorText
                   
                }
                .padding()
            }
            
            
            
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(backgroundGradient.ignoresSafeArea())
    .onAppear {
        initializeClient()
    }
}
    
    private var textEditor: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: $prompt)
                .frame(height: 100) // Adjust the height as needed
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)) // Adjust padding
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1) // Add border
                )

            if prompt.isEmpty {
                Text("Enter text which describes what you are searching for")
                    .foregroundColor(.gray)
                    .padding(.leading, 16) // Adjust padding to align with TextEditor's text
                    .padding(.top, 12) // Adjust for top padding
            }
        }
        .frame(maxWidth: 300) // Adjust maxWidth for centering and sizing
    }




private var loadingOrImage: some View {
    Group {
        if isLoading {
            ProgressView()
        } else if let imageURL = imageURL {
            imageDisplay
            ShareLink("Export", item: imageURL)
                .padding()
        }
    }
}

private var imageDisplay: some View {
    AsyncImage(url: imageURL) { imagePhase in
        switch imagePhase {
        case .empty:
            ProgressView()
        case .success(let image):
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 300)
        case .failure:
            Text("Failed to load image").foregroundColor(.red)
        @unknown default:
            EmptyView()
        }
    }
}

private var errorText: some View {
    Group {
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
        }
    }
}

private var generateButton: some View {
    Button("Generate") {
        Task {
            await generateImage()
        }
    }
    .disabled(prompt.isEmpty)
    .buttonStyle(CustomButtonStyle())
}

private var newSearchButton: some View {
    Group {
        if imageURL != nil {
            Button("New Search") {
                // Reset for a new search
                imageURL = nil
                errorMessage = nil
                prompt = ""
            }
            .buttonStyle(CustomButtonStyle())
        }
    }
}

private func initializeClient() {
    if let token = userManager.getApiKey() {
        client = Replicate.Client(token: token)
    }
}

private func generateImage() async {
    guard let client = client else {
        errorMessage = "Client not initialized"
        return
    }

    isLoading = true
    errorMessage = nil
    imageURL = nil

    do {
        let input = StableDiffusion.Input(prompt: prompt)
        var prediction = try await StableDiffusion.predict(with: client, input: input)

        while prediction.status == .starting {
            // Wait for a few seconds before polling again
            try await Task.sleep(nanoseconds: 3_000_000_000)  // 3 seconds
            prediction = try await client.getPrediction(StableDiffusion.Prediction.self, id: prediction.id)
        }

        if prediction.status == .succeeded, let firstURL = prediction.output?.first {
            print("Received prediction: \(prediction)")
            imageURL = firstURL
            
        } else {
            errorMessage = "Failed to obtain results or no URLs in output"
        }
        
    } catch {
        print("Error during prediction: \(error)")
        errorMessage = error.localizedDescription
    }

    isLoading = false
}
}

// Dutput type  prediction
struct PredictionOutput: Codable {
    var url: URL?
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchView()
            .environmentObject(UserManager.shared)
    }
}
