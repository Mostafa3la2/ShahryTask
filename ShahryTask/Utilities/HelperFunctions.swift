////
////  HelperFunctions.swift
////  Maan
////
////  Created by DP on February/16/19.
////  Copyright © 2019 DP. All rights reserved.
////
//
import Foundation
import UIKit
import SwiftyJSON
import SwiftMessages
import Alamofire
public func validateResponse(response:AFDataResponse<Any>,showNotification:Bool = true) ->Bool{
    print(response.response?.statusCode)
    switch response.result {
    case .success:
        guard let code = response.response?.statusCode  else {return false}
        switch code {
        case SUCCESS:

            return true
        case CREATED:

            return true
        case 202:

            return true
        case 203...300:

            return true
        case 401:
            let message = JSON(response.value!)
            if let error = message["message"].string{
                if showNotification{
                    ErrorMessage(title: "error", body: error)
                }
            }
            return false
        case 422:
            let message = JSON(response.value!)
            if let error = message["message"].string{
                ErrorMessage(title: "error", body: error)
            }
            return false
        case 402...505:
            
            let message = JSON(response.value!)
            
            if let error = message["message"].string{
                if showNotification{
                    ErrorMessage(title: "error", body: error)
                }
            }
            return false
        default:
            return false
        }
    case .failure:
        if showNotification{
            ErrorMessage(title: "Error", body: "Server Timed Out")
        }
        return false
    }
}
func SuccessMessage(title:String,body:String){
    let success = MessageView.viewFromNib(layout: .statusLine)
    //success.configureTheme(.success)
    success.configureTheme(backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    success.configureDropShadow()
    success.configureContent(title: title, body: body)
    let successConfig = SwiftMessages.defaultConfig
    success.button?.isHidden = true
    SwiftMessages.show(config: successConfig, view: success)
}
func WarningMessage(title:String,body:String){
    let warning = MessageView.viewFromNib(layout: .statusLine)
    //warning.configureTheme(.warning)
    warning.configureTheme(backgroundColor: #colorLiteral(red: 1, green: 0.8710392072, blue: 0.3020176457, alpha: 1), foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    warning.configureDropShadow()
    warning.configureContent(title: title, body: body)
    let warningConfig = SwiftMessages.defaultConfig
    warning.button?.isHidden = true
    SwiftMessages.show(config: warningConfig, view: warning)
    
}
func LargeWarningMessage(title:String,body:String){
    let warning = MessageView.viewFromNib(layout: .cardView)
    //warning.configureTheme(.warning)
    warning.configureTheme(backgroundColor: #colorLiteral(red: 1, green: 0.8710392072, blue: 0.3020176457, alpha: 1), foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    warning.configureDropShadow()
    warning.configureContent(title: title, body: body)
    let warningConfig = SwiftMessages.defaultConfig
    warning.button?.isHidden = true
    SwiftMessages.show(config: warningConfig, view: warning)
    
}
func ErrorMessage(title:String,body:String){
    let error = MessageView.viewFromNib(layout: .statusLine)
    //error.configureTheme(.error)
    error.configureTheme(backgroundColor: #colorLiteral(red: 1, green: 0.2583575746, blue: 0.3867297079, alpha: 1), foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    error.configureDropShadow()
    error.configureContent(title: title, body: body)
    let errorConfig = SwiftMessages.defaultConfig
    error.button?.isHidden = true
    SwiftMessages.show(config: errorConfig, view: error)
    
}
func errorHighlightTextField(textField: UIView){
    textField.borderWidth = 3
    textField.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
}

// needs more optimization later
func removeErrorHighlightTextField(textField: [UIView]){
    for i in textField{
        i.borderWidth = 0
        //i.borderColor = UIColor.darkGray
    }
}
func removeErrorHighlightBorderedTextField(textField: [UIView]){
    for i in textField{
        i.borderColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        i.borderWidth = 1
    }
}




func fromStampToString(time: TimeInterval) -> String {
    
    let date = Date(timeIntervalSince1970: time)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "YYYY-MM-dd hh:mm" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}


func setDate(date:String)->String{
    if date != ""{
        let dateFormatter = ISO8601DateFormatter()
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [.withInternetDateTime,.withFractionalSeconds]
        var dt = dateFormatter.date(from: date)
        let dtString =  dateFormatter.string(from: dt!)
        let otherDateFormatter = DateFormatter()
        otherDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZ"
        dt = otherDateFormatter.date(from: dtString)
        otherDateFormatter.dateStyle = .medium
        otherDateFormatter.timeStyle = .none
        return otherDateFormatter.string(from: dt!)
    }
    else{return ""}
}
