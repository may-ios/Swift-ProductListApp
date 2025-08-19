//
//  ProductListViewController.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import UIKit

// MARK: - String 확장
extension String {
    
    // NSString 타입으로 변환
    var nsString: NSString { self as NSString }
    
    /// 단일 attribute 문자열 생성해서 NSMutableAttributedString로 반환
    /// - Parameters:
    ///   - value: 속성을 적용할 텍스트 (nil인 경우 전체 문자열)
    ///   - attribute: 적용할 속성들
    public func attributed(value: String? = nil, attribute: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes(attribute, range: nsString.range(of: value ?? self))
        return attributedString
    }
    
    /// 다중 attribute 문자열 생성해서 NSMutableAttributedString로 반환
    /// - Parameter attributes: (텍스트, 속성) 튜플 배열
    public func attributed(attributes: [ (value: String, attribute: [NSAttributedString.Key: Any]) ]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributes.forEach {
            attributedString.addAttributes($0.attribute, range: nsString.range(of: $0.value))
        }
        return attributedString
    }
}

