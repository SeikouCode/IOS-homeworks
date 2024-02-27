//
//  CastCollectionViewCell.swift
//  IMDb
//
//  Created by Aneli  on 05.02.2024.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Public Methods
    
    func configure(with castMember: CastElement) {
        if let profilePath = castMember.profilePath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w185" + profilePath)
            actorImageView.kf.setImage(with: imageURL)
        } else {
            actorImageView.image = UIImage(named: "placeholder_actor")
        }
        nameLabel.text = castMember.name
        roleLabel.text = castMember.character
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        [actorImageView, nameLabel, roleLabel].forEach {
            addSubview($0)
        }
        
        actorImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(16)
            make.size.equalTo(50)
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(actorImageView.snp.right).offset(8)
            make.top.equalTo(actorImageView)
            make.right.equalToSuperview().inset(16)
        }

        roleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.right.equalTo(nameLabel)
            make.bottom.equalTo(actorImageView)
        }
    }
}


