//
//  UIFont+Extension.swift
//  ProductListApp
//
//  Created by kme on 8/15/25.
//

import Foundation
import UIKit

// MARK: - UIFont 확장
extension UIFont {
    
    /// AppleSDGothicNeo 폰트 스타일 - 한글 가능
    enum AppleSDGothicNeo: String, Fontable {
        case regular    = "AppleSDGothicNeo-Regular"
        case light      = "AppleSDGothicNeo-Light"
        case medium     = "AppleSDGothicNeo-Medium"
        case semiBold   = "AppleSDGothicNeo-SemiBold"
        case bold       = "AppleSDGothicNeo-Bold"
        
        var name: String {
            rawValue
        }
    }
    
    /// Helvetica 폰트 스타일
    enum Helvetica: String, Fontable {
        case regular    = "Helvetica"
        case light      = "Helvetica-Light"
        case medium     = "HelveticaNeue-Medium"
        case bold       = "Helvetica-Bold"
        
        var name: String {
            rawValue
        }
    }
}

