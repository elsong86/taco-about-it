import Foundation
import KeychainAccess

class SessionManager {
    static let shared = SessionManager()
    
    private let keychain = Keychain(service: "com.tacoaboutit.app")
    private let baseURL = "https://api.tacoaboutit.app"
    private let appSecret = "your_embedded_app_secret" // Replace with your actual app secret
    
    private(set) var sessionToken: String?
    private(set) var sessionExpiry: Date?
    
    private init() {
        // Try to load session from keychain on init
        loadSession()
    }
    
    // Check if we have a valid session
    var hasValidSession: Bool {
        guard let token = sessionToken, let expiry = sessionExpiry else {
            return false
        }
        // Check if token is not expired (with 1 hour buffer)
        return expiry > Date().addingTimeInterval(3600)
    }
    
    // Create a new session
    func createSession() async throws -> String {
        guard let url = URL(string: "\(baseURL)/create-session") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(appSecret, forHTTPHeaderField: "X-App-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // Parse response
        struct SessionResponse: Decodable {
            let token: String
            let expiresAt: Date
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let sessionResponse = try decoder.decode(SessionResponse.self, from: data)
        
        // Store session
        self.sessionToken = sessionResponse.token
        self.sessionExpiry = sessionResponse.expiresAt
        
        // Save to keychain
        try saveSession()
        
        return sessionResponse.token
    }
    
    // Ensure we have a valid session, creating one if needed
    func ensureValidSession() async throws -> String {
        if hasValidSession, let token = sessionToken {
            return token
        }
        
        // Create new session
        return try await createSession()
    }
    
    // Save session to keychain
    private func saveSession() throws {
        guard let token = sessionToken, let expiry = sessionExpiry else {
            return
        }
        
        try keychain.set(token, key: "sessionToken")
        try keychain.set(expiry.timeIntervalSince1970.description, key: "sessionExpiry")
    }
    
    // Load session from keychain
    private func loadSession() {
        do {
            if let token = try keychain.getString("sessionToken"),
               let expiryString = try keychain.getString("sessionExpiry"),
               let expiryInterval = Double(expiryString) {
                
                sessionToken = token
                sessionExpiry = Date(timeIntervalSince1970: expiryInterval)
            }
        } catch {
            print("Failed to load session: \(error)")
            // Continue without session, will create a new one when needed
        }
    }
    
    // Clear session (for troubleshooting or logout)
    func clearSession() throws {
        sessionToken = nil
        sessionExpiry = nil
        try keychain.remove("sessionToken")
        try keychain.remove("sessionExpiry")
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
}
