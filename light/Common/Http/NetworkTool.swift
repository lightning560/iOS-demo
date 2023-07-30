//
//  NetworkTool.swift
//  light
//
//  Created by LiangNing on 2023/07/13.
//
import Alamofire
import Combine
import Foundation
import SwiftUI

enum APIError: Error {
    case custom(msg: String)
}

struct NetworkTool {
    static func awaitRequest<T, V>(request: T, responseType: V.Type) async throws -> NetworkBaseModel<V> where T: BaseRequestProtocol, V: Codable {
        try await withUnsafeThrowingContinuation({ continuation in
            let api = AF.request(request)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: [NetworkConfig.contentType])
                .cURLDescription { _ in
                    Dlog("\n=====请求接口的详细信息====")
                    Dlog("api: \(request.urlRequest?.url?.absoluteString ?? "")")
                    Dlog("params: \(request.parameters ?? [:])")
                }
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let model = try JSONDecoder().decode(NetworkBaseModel<V>.self, from: data)
                            // 拦截错误，抛出异常
                            if model.code != 0 {
                                continuation.resume(throwing: APIError.custom(msg: model.message ?? "未知错误 unknow error"))
                                return
                            }
                            continuation.resume(returning: model)
                        } catch {
                            //                            promise(.failure(APIError.custom(msg: error.localizedDescription)))
                            continuation.resume(throwing: error)
                        }

                    case let .failure(error):
                        //                        promise(.failure(APIError.custom(msg: error.localizedDescription)))
                        continuation.resume(throwing: error)
                    }
                }

            api.resume()
        })
    }

    static func publishRequest<T, V>(request: T, responseType: V.Type) -> Future<NetworkBaseModel<V>, APIError> where T: BaseRequestProtocol, V: Codable {
        return Future { promise in

            let api = AF.request(request)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: [NetworkConfig.contentType])
                .cURLDescription { text in
                    Dlog(text)
                }
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        Dlog(data)
                        do {
                            let model = try JSONDecoder().decode(NetworkBaseModel<V>.self
                                                                 , from: data)

                            promise(.success(model))
                        } catch {
                            promise(.failure(APIError.custom(msg: error.localizedDescription)))
                        }

                    case let .failure(error):

                        promise(.failure(APIError.custom(msg: error.localizedDescription)))
                    }
                }

            api.resume()
        }
    }
}
