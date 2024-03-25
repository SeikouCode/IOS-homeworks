//
//  PhotoCollectionViewCell.swift
//  IMDb
//
//  Created by Aneli  on 19.02.2024.
//

import UIKit
import Kingfisher
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1065)
            make.left.equalToSuperview().offset(34)
            make.width.equalTo(63)
            make.height.equalTo(107)
        }
    }
}
