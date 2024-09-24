//
//  NetworkService.swift
//  MovieRama
//
//  Created by Kostas Michalakakis on 19/9/24.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()

    func apiGetRequest<T: Decodable>(urlPath: String, responseDecodeType: T.Type, completion: @escaping (_ response: (data: T?, error: Error?)) -> Void) {
        let parameters: Parameters = [
                "api_key": "30842f7c80f80bb3ad8a2fb98195544d"  // This depends on the API's requirements
            ]
        var responseObject: T?
        var responseError: Error?

        print("Start GET request for \(urlPath)")
        AF.request(urlPath, method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                 //   print("JSON RESPONSE from \(urlPath)")
                //    print(json as Any)
                    responseObject = try JSONDecoder().decode(responseDecodeType, from: data)
                } catch {
                    responseError = error
                    print("Error trying to create object from response \(urlPath)")
                    print(error)
                }
            case .failure(let error):
                
                print("An ERROR with code \(error) occured trying to reach \(urlPath)")
            }
            completion((responseObject, responseError))
        }
    }
}
