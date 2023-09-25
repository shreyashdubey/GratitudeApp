//
//  ReachabilityManager.swift
//  Gratitude
//
//  Created by Shreyash on 9/23/23.
//

import Foundation
import SystemConfiguration
import Network

open class ReachabilityManager {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            
            return false
        }
        let isReachable = flags.contains(.reachable)
        
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
enum NetworkStatus: String {
    case connected
    case disconnected
}
class NetworkObserver: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
//requiredInterfaceType: .wifi
    @Published var status: NetworkStatus = .connected

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                print("path.status", path.status)
                print("path.status", path.availableInterfaces)
                if path.status == .unsatisfied {
                    print("No connection.")
                    self.status = .disconnected
                    
                } else {
                    print("We're connected!")
                    
                    if path.usesInterfaceType(.cellular) {
                        print("Cellular")
                        self.status = .connected
                    }
                    else if path.usesInterfaceType(.wifi) {
                        print("WIFI")
                        self.status = .connected
                    }else{
                        self.status = .disconnected
                    }
                    
                }
            }
        }
        monitor.start(queue: queue)
    }
}
