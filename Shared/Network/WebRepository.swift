// The MIT License (MIT)
//
// Copyright (c) 2020-Present Paweł Wiszenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import Foundation

protocol WebRepository {
    associatedtype ErrorResponse: ErrorResponseDecodable

    var session: URLSession { get }
}

extension WebRepository {
    func fetch(url: URL) -> AnyPublisher<Data, APIError> {
        session.dataTaskPublisher(for: .init(url: url))
            .mapError { error in
                if error.code.rawValue == -1009 {
                    return .offline
                }
                return .network(
                    code: error.code.rawValue,
                    description: error.localizedDescription
                )
            }
            .map(\.data)
            .eraseToAnyPublisher()
    }

    func fetchAPIResource<Resource>(_ resource: Resource) -> AnyPublisher<Resource.Response, APIError>
        where Resource: APIResource
    {
        guard let url = resource.url else {
            return Fail(error: .invalidRequest(description: "Invalid url"))
                .eraseToAnyPublisher()
        }
        return fetch(url: url)
            .flatMap(decode)
            .eraseToAnyPublisher()
    }

    private func decode<Response>(data: Data) -> AnyPublisher<Response, APIError>
        where Response: Decodable
    {
        if let response = try? JSONDecoder().decode(Response.self, from: data) {
            return Just(response)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            return Fail(error: .invalidRequest(description: errorResponse.error))
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknown)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - APIResource

protocol APIResource {
    associatedtype Response: Decodable
    var serverPath: String { get }
    var methodPath: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension APIResource {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = serverPath
        components.path = methodPath
        components.queryItems = queryItems
        return components.url
    }
}

// MARK: - APIError

enum APIError: Error {
    case offline
    case network(code: Int, description: String)
    case invalidRequest(description: String)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(_, let description), .invalidRequest(let description):
            description
        case .offline:
            "Offline"
        case .unknown:
            "Unknown error"
        }
    }
}

// MARK: - ErrorResponseDecodable

protocol ErrorResponseDecodable: Decodable {
    var error: String { get }
}
