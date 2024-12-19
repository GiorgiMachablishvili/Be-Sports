//
//  NetworkManger.swift
//  Betus
//
//  Created by Gio's Mac on 29.11.24.
//

import UIKit
import Alamofire
import ProgressHUD
import SVProgressHUD

// Define a generic result type
enum Result<T> {
    case success(T)
    case failure(Error)
}

// Define a protocol for the NetworkManager to follow
protocol NetworkManagerProtocol {
    func request<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void)
    func get<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void)
    func post<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void)
    func put<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void)
    func delete<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void)
    func uploadMultipart<T: Decodable>(url: String, params: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void)
}

// Create a generic NetworkManager class
class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()

    private init() {}

    func request<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func showProgressHud(_ show: Bool, animated: Bool = true) {
        if show {
            ProgressHUD.added()
        } else {
            ProgressHUD.dismiss()
        }
    }

    func get<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void) {
        request(url: url, method: .get, parameters: parameters, headers: headers, completion: completion)
    }

    func post<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void) {
        request(url: url, method: .post, parameters: parameters, headers: headers, completion: completion)
    }

    func delete<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void) {
        request(url: url, method: .delete, parameters: parameters, headers: headers, completion: completion)
    }
    
    func put<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void) {
        request(url: url, method: .put, parameters: parameters, headers: headers, completion: completion)
    }

    func uploadMultipart<T: Decodable>(url: String, params: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T>) -> Void) {
        // Set a maximum chunk size (e.g., 1 MB)
        let maxChunkSize = 1 * 1024 * 1024 // 1 MB

        AF.upload(multipartFormData: { multipartFormData in
            guard let params = params else { return }
            for (key, value) in params {
                if let dataValue = value as? Data {
                    if dataValue.count > maxChunkSize {
                        // Split large data into smaller chunks
                        var offset = 0
                        while offset < dataValue.count {
                            let chunkSize = min(maxChunkSize, dataValue.count - offset)
                            let chunk = dataValue.subdata(in: offset..<offset + chunkSize)
                            multipartFormData.append(chunk, withName: key, fileName: "\(key)_part_\(offset).jpg", mimeType: "image/jpeg")
                            offset += chunkSize
                        }
                    } else {
                        // If data is smaller than maxChunkSize, upload it directly
                        multipartFormData.append(dataValue, withName: key, fileName: "\(key).jpg", mimeType: "image/jpeg")
                    }
                } else if let stringValue = value as? String {
                    multipartFormData.append(Data(stringValue.utf8), withName: key)
                } else if let doubleValue = value as? Double {
                    multipartFormData.append(Data("\(doubleValue)".utf8), withName: key)
                } else if let boolValue = value as? Bool {
                    multipartFormData.append(Data("\(boolValue)".utf8), withName: key)
                }
            }
        }, to: url, headers: headers)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
