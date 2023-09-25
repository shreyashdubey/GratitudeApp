//
//  ApiSessionHandler.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/23/23.
//

import Foundation

class NetworkSessionHandler: NSObject, URLSessionDelegate {
    
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        // Indicate network status, e.g., offline mode
//        print("taskIsWaitingForConnectivity")
//        print("taskIsWaitingForConnectivity-task",task)
//        print("taskIsWaitingForConnectivity-session",session)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest: URLRequest, completionHandler: (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        // Indicate network status, e.g., back to online
//        print("willBeginDelayedRequest")
//        print("willBeginDelayedRequest-task",task)
//        print("willBeginDelayedRequest-session",session)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
//        print("didBecomeInvalidWithError")
//        print("didBecomeInvalidWithError-session",session)
//        print("didBecomeInvalidWithError-error",error)
    }
    
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        print("urlSessionDidFinishEvents-forBackgroundURLSession", session)
    }

}


