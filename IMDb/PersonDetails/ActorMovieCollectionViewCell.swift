//
//  ActorMovieCollectionViewCell.swift
//  IMDb
//
//  Created by Aneli  on 19.02.2024.
//

import UIKit
import Kingfisher

class ActorMovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let yearLabel: UILabel = {
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
                
    func configure(with result: Result) {
        if !result.posterPath.isEmpty, let imageURL = URL(string: "https://image.tmdb.org/t/p/w185" + result.posterPath) {
            posterImageView.kf.setImage(with: imageURL)
        } else {
            posterImageView.image = UIImage(named: "placeholder_movie")
        }
        titleLabel.text = result.title
        yearLabel.text = result.releaseDate
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        [posterImageView, titleLabel, yearLabel].forEach {
            addSubview($0)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(16)
            make.size.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(8)
            make.top.equalTo(posterImageView)
            make.right.equalToSuperview().inset(16)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(posterImageView)
        }
    }
}

