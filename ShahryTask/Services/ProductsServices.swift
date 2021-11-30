//
//  ProductsServices.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 02/11/2021.
//

import Foundation
import Alamofire
import Moya


//rewriting the network layer using Moya
enum ProductsServices{
    static let PAGINATION_LIMIT = 20
    case getProducts(limit:Int = 5)
}

extension ProductsServices:TargetType{
    var baseURL :URL{
        return URL(string: "https://fakestoreapi.com/products")!
    }
    var path: String{
        switch self{
        case .getProducts:
            return "/"
        }
    }
    var method: Moya.Method{
        switch self{
        case .getProducts:
            return .get
        }
    }
    
    var sampleData: Data{
        return Data()
    }
    var task:Task{
        switch self{
        case .getProducts(let limit):
            return .requestParameters(parameters: ["limit":"\(limit)"], encoding: URLEncoding.default)
        }
    }
    var headers: [String : String]?{
        return [:]
    }
}

protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class CachePolicyPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }

        return request
    }
}

extension ProductsServices:CachePolicyGettable{
    var cachePolicy: URLRequest.CachePolicy {
        switch self{
        case .getProducts:
            return .returnCacheDataElseLoad
        }
    }
}

//Alamofire approach


//enum ProductsServices{
//    case sharedInstance
//    static let PAGINATION_LIMIT = 20
//    static let sessionManager: Session = {
//        let configuration = URLSessionConfiguration.af.default
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
//        let responseCacher = ResponseCacher(behavior: .modify { _, response in
//          let userInfo = ["date": Date()]
//          return CachedURLResponse(
//            response: response.response,
//            data: response.data,
//            userInfo: userInfo,
//            storagePolicy: .allowed)
//        })
//
//          let networkLogger = NetworkLogger()
//          let interceptor = ProductsRequestInterceptor()
//
//        return Session(
//          configuration: configuration,
//          cachedResponseHandler: responseCacher,
//          eventMonitors: [networkLogger])
//      }()
//
//
//
//    func getProducts(limit:Int = 5,completion:@escaping(_ success:Bool,_ productsData:[ProductModel]?)->()){
//        let url = BASE_URL + "?limit=\(limit)"
//
//        //let params = ["limit":"\(limit)"]
////        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
////        request.method = .get
//
//        //AF.request(request).response{(data) in print(data)}
//        ProductsServices.sessionManager.request(url).responseJSON { (response) in
//
//            if validateResponse(response: response){
//                let decoder = JSONDecoder()
//                do{
//                    let productsData = try decoder.decode([ProductModel].self, from: response.data!)
//                    completion(true,productsData)
//                }catch{
//                    //print(error.localizedDescription)
//                    completion(false,nil)
//                }
//            }else{
//                completion(false,nil)
//
//            }
//        }
//    }
//
////        sessionManager.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
////            print(response.value)
////            if validateResponse(response: response){
////
////                let decoder = JSONDecoder()
////                do{
////                    let productsData = try decoder.decode([ProductModel].self, from: response.data!)
////                    completion(true,productsData)
////                }catch{
////                    print(error.localizedDescription)
////                    completion(false,nil)
////                }
////            }else{
////
////                completion(false,nil)
////
////            }
////        }
////  }
//
//}
