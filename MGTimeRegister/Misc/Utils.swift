//
//  Utils.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import MapKit
import Photos
import Foundation
import SystemConfiguration

public class Utils {
    public static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    public static func addressFromPlacemark(placemark: MKPlacemark) -> String {
        var address : String = Strings.empty
        
        if Strings.notNullOrEmpty(placemark.locality) {
            address = placemark.locality!
            if Strings.notNullOrEmpty(placemark.thoroughfare){
               address = address.appendingFormat(", %@", placemark.thoroughfare!)
                if Strings.notNullOrEmpty(placemark.subThoroughfare){
                    address = address.appendingFormat(", %@", placemark.subThoroughfare!)
                }
            }
            if Strings.notNullOrEmpty(placemark.postalCode) {
                address = address.appendingFormat(", %@", placemark.postalCode!)
            }
            if Strings.notNullOrEmpty(placemark.subAdministrativeArea) {
                address = address.appendingFormat(", (%@)", placemark.subAdministrativeArea!)
            }
        }
        return address
    }
    
    public static func checkAuthPhoto(completion: @escaping(_ authorized: Bool)->()){
        let status : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if (status == .authorized) {
            completion(true)
        }
        else if (status == .denied) {
            completion(false)
        }
        else if (status == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    if status == .authorized{
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                }
            })
        }
    }
    
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}
