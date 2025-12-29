import Foundation
import UIKit

enum APIError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case decodingError
}

struct GenerationResponse: Decodable {
    let sessionId: String
    let originalImageUrl: String?
    let editedImageUrl: String
    // characterCard is null initially
}

struct CharacterCard: Decodable {
    let name: String
    let personality: String
    let voiceStyle: String
    let backstory: String
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    // MARK: - Upload Image
    func uploadImage(_ image: UIImage) async throws -> GenerationResponse {
        guard let url = URL(string: "\(Config.baseURL)/api/generate-cute-face") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createMultipartBody(image: image, boundary: boundary)
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // print("Server Error: \(String(data: responseData, encoding: .utf8) ?? "")")
            throw APIError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(GenerationResponse.self, from: responseData)
            return result
        } catch {
            print("Decoding Error: \(error)")
            throw APIError.decodingError
        }
    }
    
    // MARK: - Generate Character Card (Step 2)
    func generateCharacterCard(sessionId: String) async throws -> CharacterCard {
        guard let url = URL(string: "\(Config.baseURL)/api/character-card") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["sessionId": sessionId]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.invalidResponse }
        
        struct CardResponse: Decodable {
            let characterCard: CharacterCard
        }
        let result = try JSONDecoder().decode(CardResponse.self, from: data)
        return result.characterCard
    }
    
    // MARK: - Helper: Multipart Builder
    private func createMultipartBody(image: UIImage, boundary: String) -> Data {
        var body = Data()
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return body }
        
        let filename = "photo.jpg"
        let mimeType = "image/jpeg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
