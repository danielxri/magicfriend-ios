import Foundation
// import Alamofire // Uncomment when pod installed

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func checkHealth() async throws -> Bool {
        guard let url = URL(string: "\(Config.baseURL)/health") else { return false }
        
        // Placeholder for Alamofire
        let (data, response) = try await URLSession.shared.data(from: url)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    // Future: implement uploadPhoto(image: UIImage)
}
