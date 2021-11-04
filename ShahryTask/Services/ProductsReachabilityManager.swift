//
//  ProductsReachabilityManager.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 04/11/2021.
//

import Foundation

import UIKit
import Alamofire

class ProductsNetworkReachability {
    static let shared = ProductsNetworkReachability()
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
 
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.showOfflineAlert()
            case .reachable(.cellular):
                self.dismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknown network state")
            }
        }
    }
    
    func showOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        let alert:UIAlertController = UIAlertController(title: "No Network", message: "Please connect to network and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(_) in alert.dismiss(animated: true)}))
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func dismissOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}
