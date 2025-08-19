//
//  TextBoxCell.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import UIKit

// MARK: - TextBoxCell
/// HorizontalTextBoxView에서 사용하는 태그 셀
class TextBoxCell: UICollectionViewCell, Cellable{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        // 기본 라벨 스타일 설정
        nameLabel.font = UIFont.AppleSDGothicNeo.light.font(size: 10)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
    }
    
    /// 셀 재사용 준비
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    /// 셀 데이터 구성
    func configure(text: String) {
        nameLabel.text = text
    }
    
    // MARK: 동적 셀 크기 조정
    /// 텍스트 크기에 맞게 셀 크기 자동 조정
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let fittingSize = systemLayoutSizeFitting(
            CGSize(width: UIView.layoutFittingCompressedSize.width, height: layoutAttributes.frame.height),
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
        attributes.frame.size = fittingSize
        return attributes
    }
}
