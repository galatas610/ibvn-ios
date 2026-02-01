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
