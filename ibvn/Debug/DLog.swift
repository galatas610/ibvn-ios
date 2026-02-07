//
//  DLog.swift
//  ibvn
//
//  Created by joseletona on 31/1/26.
//

import Foundation

func DLog(
    _ items: Any...,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
#if DEBUG
    let filename = (file as NSString).lastPathComponent
    print("🟣 [\(filename):\(line)] \(function) →", items)
#endif
}

func DHTTPError(
    data: Data?,
    response: URLResponse?,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
#if DEBUG
    let filename = (file as NSString).lastPathComponent
    
    if let http = response as? HTTPURLResponse {
        print("🔴 [\(filename):\(line)] \(function)")
        print("   Status:", http.statusCode)
        print("   URL:", http.url?.absoluteString ?? "nil")
    }
    
    if let data,
       let body = String(data: data, encoding: .utf8) {
        print("   Body:", body)
    }
#endif
}
