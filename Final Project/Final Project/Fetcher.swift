//
//  Fetcher.swift
//  Final Project
//
//  Created by Ken Zhang on 7/27/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation

class Fetcher: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    func session() -> NSURLSession {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30.0
        return NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    //MARK: NSURLSessionTaskDelegate
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    typealias RequestCompletionHandler = (data: NSData?, message: String?) -> Void
    func request(url: NSURL, completion: RequestCompletionHandler) {
        let task = session().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, netError: NSError?) in
            let message = self.parseResponse(response, error: netError)
            completion(data:data, message: message)
        }
        task.resume()
    }
    
    typealias JSONRequestCompletionHandler = (json:NSObject?, message: String?) -> Void
    func requestJSON(url: NSURL, completion: JSONRequestCompletionHandler) {
        request(url) { (data, message) in
            
            var json: NSObject?
            if let data = data {
                json = try? NSJSONSerialization
                    .JSONObjectWithData(data,
                                        options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            }
            completion(json: json, message: message)
            print("requestJSON did work where json is \(json)")
        }
    }
    
    
    func parseResponse(response: NSURLResponse?, error: NSError?) -> String? {
        if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
            if statusCode == 200 {
                return nil
            }
            else {
                return "HTTP Error \(statusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))"
            }
        }
        else {
            if let netErr = error {
                return "Network Error: \(netErr.localizedDescription)"
            }
            else {
                return "OS Error: network error was empty"
            }
        }
    }
}

//MARK: NSURLSessionDelegate
extension Fetcher {
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        NSLog("\(#function): Session became invalid: \(error?.localizedDescription)")
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
    }
}