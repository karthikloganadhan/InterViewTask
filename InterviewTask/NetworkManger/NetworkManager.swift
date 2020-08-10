//
//  NetworkManager.swift
//  InterviewTask
//
//  Created by Admin on 06/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration

struct NetworkManager {
    
    static let shared = NetworkManager()
    private let url = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    func fetchDataFromServer(withCompletion completion: @escaping (FactsResponse?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in            
            if let dataReceived = data {
                if let value = String(data: dataReceived, encoding: String.Encoding.ascii) {
                    if let jsonData = value.data(using: String.Encoding.utf8) {
                        do {
                            let response = try JSONDecoder().decode(FactsResponse.self, from: jsonData)
                            completion(response, nil)
                        } catch {
                            NSLog("ERROR \(error.localizedDescription)")
                        }
                    }
                }
            }
        }.resume()
    }
}



public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
