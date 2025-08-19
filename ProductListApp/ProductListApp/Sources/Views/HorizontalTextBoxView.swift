//
//  HorizontalTextBoxView.swift
//  ProductListApp
//
//  Created by kme on 8/19/25.
//

import Foundation
import UIKit

// MARK: - HorizontalTextBoxView
/// Text(Tag)를 박스,가로로 표시하는 커스텀 뷰, XIB/스토리보드에서 사용 가능
@IBDesignable
class HorizontalTextBoxView: UIView {
    private var tags: [String] = []
    private var collectionView: UICollectionView!
    
    // MARK: - IBInspectable 속성들 (Interface Builder에서 설정 가능)
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet { updateCellStyle() } // 코너 반경 변경 시 셀 스타일 갱신
    }
    
    @IBInspectable var tagTextColor: UIColor = .secondaryLabel {
        didSet { updateCellStyle() } // 태그 텍스트 색상 변경 시 갱신
    }
    
    @IBInspectable var tagBackgroundColor: UIColor = .secondarySystemBackground{
        didSet { updateCellStyle() } // 태그 배경 색상 변경 시 갱신
    }
    
    @IBInspectable var tagFont: UIFont = UIFont.AppleSDGothicNeo.light.font(size: 10) {
        didSet { updateCellStyle() } // 태그 폰트 변경 시 갱신
    }
    
    // MARK: - 초기화 메서드들
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    // MARK: 컬렉션 뷰 설정
    private func setupCollectionView() {
        // 기존 컬렉션뷰 제거
        collectionView?.removeFromSuperview()
        
        // 가로 스크롤 레이아웃 생성
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.estimatedItemSize = CGSize(width: 50, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 컬렉션 뷰 초기화
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(cell: TextBoxCell.self, dataSource: self)
        
        // 컬렉션 뷰를 뷰에 추가 및 오토레이아웃 설정
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: 셀 스타일 업데이트 (IBInspectable 속성 변경 시 호출)
    private func updateCellStyle() {
        collectionView?.reloadData()
    }
    
    // MARK: - 공개 메서드
    func setTags(_ tags: [String]) {
        self.tags = tags
        collectionView?.contentOffset = .zero
        collectionView?.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = bounds
    }
}

// MARK: - Collection View DataSource
extension HorizontalTextBoxView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       let cell: TextBoxCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        // 스타일 적용
        cell.layer.cornerRadius = cornerRadius
        cell.backgroundColor = tagBackgroundColor
        cell.nameLabel.textColor = tagTextColor
        cell.nameLabel.font = tagFont

        cell.configure(text: tags[indexPath.item])
        return cell
    }
}
