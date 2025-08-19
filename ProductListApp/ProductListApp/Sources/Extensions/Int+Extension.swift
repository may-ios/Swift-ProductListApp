//
//  ProductListViewController.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//


import Foundation

// MARK: - Int 확장
extension Int {
    
    /// 숫자를 세 자리마다 콤마가 포함된 숫자 문자열로 변환
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /// String 타입으로 변환
    var string: String {
        String(self)
    }
    
    /// Float 타입으로 변환
    var float: Float {
        Float(self)
    }

}
