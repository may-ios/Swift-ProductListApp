//
//  ProductCell.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import UIKit

// MARK: - ProductCell
/// 상품 리스트의 각 셀을 표시하는 커스텀 컬렉션 뷰 셀
class ProductCell: UICollectionViewCell, Cellable{

    // UI 스타일 설정을 위한 구조체 (설정 분리)
    private struct UIConfig {
        let discountRate = (
            font: UIFont.AppleSDGothicNeo.bold.font(size: 16),            // 할인율 폰트
            color: UIColor.systemRed                                      // 할인율 색상
        )
        let discountPrice = (
            font: UIFont.AppleSDGothicNeo.semiBold.font(size: 15),        // 할인 가격 폰트
            color: UIColor.label                                          // 할인 가격 색상
        )
        let originalPrice = (
            font: UIFont.AppleSDGothicNeo.light.font(size: 11),           // 원 가격 폰트
            color: UIColor.secondaryLabel                                 // 원 가격 색상
        )
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!                           // 상품 썸네일 이미지
    @IBOutlet weak var brandLabel: UILabel!                              // 브랜드 이름
    @IBOutlet weak var nameLabel: UILabel!                               // 상품 이름
    @IBOutlet weak var priceLabel: UILabel!                              // 가격 정보
    @IBOutlet weak var ratingLabel: UILabel!                             // 평점 및 리뷰 수
    
    // UI 설정 상수
    private let uiConfig = UIConfig()

    ///셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 이미지뷰 초기 설정
        imageView.image = nil
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        
        // 각 라벨의 폰트 및 색상 설정
        brandLabel.font = UIFont.AppleSDGothicNeo.semiBold.font(size: 12)
        brandLabel.textColor = .label
        nameLabel.font = UIFont.AppleSDGothicNeo.regular.font(size: 15)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .label
        priceLabel.font = uiConfig.discountPrice.font
        priceLabel.textColor = uiConfig.discountPrice.color
        ratingLabel.font = UIFont.AppleSDGothicNeo.regular.font(size: 12)
        ratingLabel.textColor = .secondaryLabel
    }
    
    /// 셀 재사용 준비
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        brandLabel.text = nil
        nameLabel.text = nil
        priceLabel.attributedText = nil
        ratingLabel.text = nil
    }
    
    /// 셀 데이터 구성
    func configure(_ product: Product, viewModel: ProductListViewModel) {
        brandLabel.text = product.brand
        nameLabel.text = product.name

        // 가격 정보를 뷰모델에서 처리하여 표시
        let priceData = viewModel.priceData(for: product)
        priceLabel.attributedText = makePriceAttributedText(priceData)
                
        // 비동기로 이미지 로딩
        Task {
            let image = await ImageManager.shared.load(from: product.image)
            imageView.image = image
        }
      
        // 평점 및 리뷰 수 표시
        ratingLabel.text = viewModel.ratingData(for: product).ratingText
    }
    
    // MARK: 가격 텍스트 포맷팅
    /// 할인 여부에 따라 가격 텍스트를 속성 문자열로 생성
    private func makePriceAttributedText(_ priceData: ProductListViewModel.PriceData) -> NSAttributedString {
                
        // 할인 있을 경우 - 할인율, 할인가격, 원래 가격 속성 설정
        if priceData.hasDiscount {
            let priceInfo = "\(priceData.discountRate) \(priceData.discountPrice) \(priceData.originalPrice)"
            return priceInfo.attributed(attributes: [
                (value: priceData.discountRate, attribute: [
                    .font : uiConfig.discountRate.font as Any,
                    .foregroundColor: uiConfig.discountRate.color
                ]),
                (value: priceData.discountPrice, attribute: [
                    .font: uiConfig.discountPrice.font as Any,
                    .foregroundColor: uiConfig.discountPrice.color
                ]),
                (value: priceData.originalPrice, attribute: [
                    .font : uiConfig.originalPrice.font as Any,
                    .foregroundColor: uiConfig.originalPrice.color,
                    .strikethroughStyle : NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: uiConfig.originalPrice.color
                ]),
            ])
        }
        else{
            // 할인 없을 경우 - 원래 가격만 속성 설정
            return priceData.discountPrice.attributed(attribute: [
                .font: uiConfig.discountPrice.font as Any,
                .foregroundColor: uiConfig.discountPrice.color
            ])
        }
     
    }
    
}
