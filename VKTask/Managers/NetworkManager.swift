import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func getServices(completion: @escaping (Result<[ServiceModel], AFError>) -> ())
}

final class NetworkManager: NetworkManagerProtocol {
    
    func getServices(completion: @escaping (Result<[ServiceModel], AFError>) -> ()) {
        AF.request(Constants.URL)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ServiceRequestModel.self) { response in
                switch response.result {
                    
                case .success(let result):
                    completion(.success(result.body.services))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

