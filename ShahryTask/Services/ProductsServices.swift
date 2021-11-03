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
    func getProducts(limit:Int = 5,completion:@escaping(_ success:Bool,_ productsData:[ProductModel]?)->()){
        
        let url = BASE_URL
        let params = ["limit":"\(limit)"]
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            if validateResponse(response: response){
                
                let decoder = JSONDecoder()
                do{
                    let productsData = try decoder.decode([ProductModel].self, from: response.data!)
                    completion(true,productsData)
                }catch{
                    print(error.localizedDescription)
                    completion(false,nil)
                }
            }else{
                completion(false,nil)
                
            }
        }
    }
}
