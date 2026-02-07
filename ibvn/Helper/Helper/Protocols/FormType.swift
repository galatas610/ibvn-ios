//
//  FormType.swift
//  ibvn
//
//  Created by joseletona on 29/1/25.
//

import Foundation

protocol FormType {
    associatedtype FocusType: FocusFieldType
    
    var focusField: FocusType? { get set }
    
    func setFocus(on focusField: FocusType?)
}

protocol FocusFieldType: Hashable {}
