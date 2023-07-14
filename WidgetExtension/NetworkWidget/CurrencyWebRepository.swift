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

    private func decode<Response>(data: Data) -> AnyPublisher<Response, APIError> where Response: Decodable {
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
