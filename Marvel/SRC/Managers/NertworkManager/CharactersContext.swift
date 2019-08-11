//
//  SearchPhotoContext.swift
//  SearchGiphy
//
//  Created by Volodymyr
//  Copyright © 2019 java. All rights reserved.
//

import Foundation

typealias CompletionHandler<T: Decodable> = ((T?, URLResponse?, Error?) -> Void)?

class CharactersContext {
    func execute(offset: Int, completionHandler: @escaping (Result<CharactersResponse, Error>) -> Void)  {
        guard let url = URL(string: Constants.Server.api + "/" + Constants.Server.characters) else {
            return
        }

        let requestParameters = RequestParameters(url: url,
                                                  method: .get,
                                                  headers: nil,
                                                  parameters: [Constants.Server.key.limit  : String(Constants.Server.offset),
                                                               Constants.Server.key.offset : String(offset),
                                                               Constants.Server.key.ts     : Constants.Server.ts,
                                                               Constants.Server.key.APIKey : Constants.Server.APIKey,
                                                               Constants.Server.key.hash   : Constants.Server.hash])
        URLSession
            .shared
            .dataTask(with: requestParameters, decoder: JSONDecoder()) { (data: CharactersResponse?, response, error) in
                guard let data = data,
                    response?.isSuccessCode() == true else {
                        error.map { completionHandler(.failure($0)) }
                        return
                }
                completionHandler(.success(data))
            }.resume()
    }
}
