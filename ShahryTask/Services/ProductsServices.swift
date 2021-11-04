//
//  ProductsServices.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 02/11/2021.
//

import Foundation
import Alamofire
enum ProductsServices{
    case sharedInstance
    static let PAGINATION_LIMIT = 20
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
          let userInfo = ["date": Date()]
          return CachedURLResponse(
            response: response.response,
            data: response.data,
            userInfo: userInfo,
            storagePolicy: .allowed)
        })

          let networkLogger = NetworkLogger()
          let interceptor = ProductsRequestInterceptor()

        return Session(
          configuration: configuration,
          cachedResponseHandler: responseCacher,
          eventMonitors: [networkLogger])
      }()


        
    func getProducts(limit:Int = 5,completion:@escaping(_ success:Bool,_ productsData:[ProductModel]?)->()){
        let url = BASE_URL + "?limit=\(limit)"
        
        //let params = ["limit":"\(limit)"]
//        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
//        request.method = .get
        
        //AF.request(request).response{(data) in print(data)}
        ProductsServices.sessionManager.request(url).responseJSON { (response) in

            if validateResponse(response: response){
                let decoder = JSONDecoder()
                do{
                    let productsData = try decoder.decode([ProductModel].self, from: response.data!)
                    completion(true,productsData)
                }catch{
                    //print(error.localizedDescription)
                    completion(false,nil)
                }
            }else{
                completion(false,nil)

            }
        }
    }
    
//        sessionManager.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
//            print(response.value)
//            if validateResponse(response: response){
//
//                let decoder = JSONDecoder()
//                do{
//                    let productsData = try decoder.decode([ProductModel].self, from: response.data!)
//                    completion(true,productsData)
//                }catch{
//                    print(error.localizedDescription)
//                    completion(false,nil)
//                }
//            }else{
//
//                completion(false,nil)
//
//            }
//        }
//  }
    
}
