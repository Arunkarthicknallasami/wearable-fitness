//
//  Reachability.swift
//  TestNetwork
//
//  Created by Jeffrey Garcia on 11/5/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//
//  Abstract:
//  iOS Reachability fails to catch the case where connected to WiFi but not logged in
//
//  Soluton:
//  - consult Reachability to enquire any phsical linkage like cellular or wifi network
//  - attempt to make a connection request to the designated host and handle the error
//  - invoke the connection request in asynchronous request to avoid blocking the main thread 
//    and make sure to set a small timeout value
//  - if the network quality is poor then signal it to the user
//
//  Referecnes:
//  http://stackoverflow.com/questions/15306658/ios-reachability-fails-to-catch-the-case-where-connected-to-wifi-but-not-logged
//  http://stackoverflow.com/questions/40183724/reachability-in-swift-3
//  http://stackoverflow.com/questions/25398664/check-for-internet-connection-availability-in-swift
//  http://stackoverflow.com/questions/36331623/ios-9-3-an-ssl-error-has-occurred-and-a-secure-connection-to-the-server-cannot
//
//  Use command-line to diagnose ATS
//  nscurl --ats-diagnostics https://www.xxx.com
//
import Foundation
import SystemConfiguration

public class CustomReachability {
    
    static let semaphore = DispatchSemaphore( value: 0 )
    
    static let HOST : String = "https://hkmvdevd3-manulife-hongkong-community.cs31.force.com"
    //static let HOST : String = "https://www.manulifemove.hk"
    
    /**
     Test the physical network availability, no matter cellular network or Wifi hotspot. However if the network is a Wifi hotspot that required web logon, the result will still be true indicating that there is a usable network without implying the connection to remote host can be made. See also isConnectedToInternet()
     
     It has been tested on iOS 9 and 10
     It has been tested on cellular and Wifi network
     
     - return: A Bool indicated if any usable network
    */
    class func isNetworkAvailable()->Bool {
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
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    /**
     Use of semaphore to make the asynchronous connection test to internet blockable with URLSession object. Make sure to set the timeout to a small value as we just want a lightweight connection test here
     
     - return: A Bool indicating internet can be connected or not with the designated host
    */
    class func isConnectedToInternet()->Bool {
        var result:Bool = false
        
        var request = URLRequest(url: URL(string: CustomReachability.HOST)!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 3.0
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, err) -> Void in
            // completion handler
            print("\(err)")
            if data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    print("\n==========================\n")
                    print("\(response)")
                    if httpResponse.statusCode == 200 {
                        result = true
                    }
                }
            }
            semaphore.signal()
        }.resume()
        
        semaphore.wait()
        return result
    }
    
    /**
     This is a thread blocking function and should only be used when necessary. Make sure you set the timeoutInterval property of NSURLRequest to a reasonable period, like 3 seconds or less. This function is deprecated since iOS9.
     
     - return: A Bool indicating internet can be connected or not with the
     designated host
    */
    class func isConnectedToInternet_NSURLConnection()->Bool {
        let url: NSURL = NSURL(string: CustomReachability.HOST)!
        
        // Notice the timeoutInterval property.
        // Since this is a synchronous request you do not want it last for a long time
        let request = NSURLRequest(url: url as URL,
                                   cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                   timeoutInterval: 3)
        var response: URLResponse?
        
        do {
            try NSURLConnection.sendSynchronousRequest(request as URLRequest,returning: &response)
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if(httpResponse.statusCode == 200) {
                    return true
                }
            }
        } catch {
            print("\n==========================\n")
            print(error)
        }
        
        return false
    }
    
}
