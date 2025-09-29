//
//  APIClient.swift
//  CryptoNetworking
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

public protocol APIClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void)
}
