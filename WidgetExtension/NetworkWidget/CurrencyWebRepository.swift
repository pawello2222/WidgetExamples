//
//  CurrencyWebRepository.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Combine
import Foundation

class CurrencyWebRepository: WebRepository {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension CurrencyWebRepository {
    struct ErrorResponse: Decodable {
        let error: String
    }
}

extension CurrencyWebRepository {
    func fetchAPIResource<Resource>(_ resource: Resource) -> AnyPublisher<Resource.Response, APIError> where Resource: APIResource {
        guard let url = resource.url else {
            let error = APIError.invalidRequest(description: "Invalid `resource.url`: \(String(describing: resource.url))")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return fetch(url: url)
            .flatMap(decode)
            .eraseToAnyPublisher()
    }

    func decode<Response>(data: Data) -> AnyPublisher<Response, APIError> where Response: Decodable {
        if let response = try? JSONDecoder().decode(Response.self, from: data) {
            return Just(response).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            return Fail(error: .invalidRequest(description: errorResponse.error)).eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknown).eraseToAnyPublisher()
        }
    }
}

// MARK: - Resource

struct CurrencyRatesResource: APIResource {
    let serverPath = "api.exchangeratesapi.io"
    let methodPath: String
    var queryItems: [URLQueryItem]?

    init(_ base: String, date: Date) {
        methodPath = "/" + Self.dateFormatter.string(from: date)
        queryItems = [URLQueryItem(name: "base", value: base)]
    }
}

extension CurrencyRatesResource {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension CurrencyRatesResource {
    struct Response: Decodable {
        let base: String
        let date: String
        let rates: [String: Double]
    }
}
