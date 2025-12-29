import SwiftUI

struct CharacterResultView: View {
    let generationResponse: GenerationResponse
    let originalImage: UIImage
    
    @State private var characterCard: CharacterCard?
    @State private var isLoadingCard = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. Hero Image
                AsyncImage(url: URL(string: generationResponse.editedImageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                    case .failure:
                        Image(uiImage: originalImage) // Fallback
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay(Color.red.opacity(0.3))
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 300)
                .padding()
                
                // 2. Character Card
                if isLoadingCard {
                    Text("Asking the object its name...")
                        .font(.headline)
                        .foregroundColor(.gray)
                    ProgressView()
                } else if let card = characterCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(card.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        
                        Text(card.personality)
                            .font(.body)
                            .italic()
                        
                        Divider()
                        
                        Text("Backstory")
                            .font(.headline)
                        Text(card.backstory)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Your New Friend")
        .task {
            // Load Character Card
            do {
                characterCard = try await APIService.shared.generateCharacterCard(sessionId: generationResponse.sessionId)
                isLoadingCard = false
            } catch {
                print("Error loading card: \(error)")
                isLoadingCard = false
            }
        }
    }
}
