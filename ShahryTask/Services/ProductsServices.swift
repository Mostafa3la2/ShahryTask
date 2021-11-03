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
    
    func getProducts(completion:@escaping(_ success:Bool,_ productsData:[ProductModel]?)->()){
        
        let url = BASE_URL
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { (response) in
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
