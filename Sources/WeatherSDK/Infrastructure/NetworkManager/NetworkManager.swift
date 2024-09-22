//
//  NetworkManager.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//


import Foundation

// MARK: - HTTPMethod Enum

public enum HTTPMethod: String {
    case GET
    case POST
}

// MARK: - NetworkManager Class

public class NetworkManager {
    // MARK: - Properties
    
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private var apiKey: String = ""
    
    private  init() {}
    
    func setApiKey(_ apiKey: String) {
        
        self.apiKey = apiKey
    }
    
    // MARK: - URLComponents Builder
    
    /// Constructs URLComponents with the provided path and query items, including the API key.
    /// - Parameters:
    ///   - path: The endpoint path (e.g., "/posts/1/comments").
    ///   - queryItems: Optional query parameters for the request.
    /// - Returns: Configured URLComponents.
    private func buildURLComponents(path: String, queryItems: [URLQueryItem]? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherbit.io"
        components.path = path
        // Append API key as a query parameter
        var combinedQueryItems = [URLQueryItem(name: "key", value: self.apiKey)]
        if let queryItems = queryItems {
            combinedQueryItems.append(contentsOf: queryItems)
        }
        components.queryItems = combinedQueryItems
        return components
    }
    
    // MARK: - Execute Request Method
    
    /// Executes a network request with the specified HTTP method.
    ///
    /// - Parameters:
    ///   - method: The HTTP method (`GET`, `POST`, etc.).
    ///   - path: The endpoint path (e.g., "/posts/1/comments").
    ///   - queryItems: Optional query parameters for the request.
    ///   - body: Optional body for `POST` requests (must conform to `Encodable`).
    /// - Returns: Decoded response of type `T`.
    /// - Throws: `NetworkError` if the request fails or decoding fails.
    public func executeRequest<T: Codable>(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil
    ) async throws -> T {
        let urlComponents = buildURLComponents(path: path, queryItems: queryItems)
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .POST, let body = body {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch {
            print(error)
            throw NetworkError.decodingError(error)
        }
    }
}

