//
//  MovieTableViewCell.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//

import UIKit
import Kingfisher
import SnapKit
import Alamofire

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var imageMovie: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var labelMovie: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String, and imagePath: String) {
        labelMovie.text = title
        
        let urlString = "https://image.tmdb.org/t/p/w200" + imagePath
        let url = URL(string: urlString)!
        imageMovie.kf.setImage(with: url)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        [imageMovie, labelMovie].forEach {
            contentView.addSubview($0)
        }
        
        imageMovie.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
        }
        
        labelMovie.snp.makeConstraints { make in
            make.top.equalTo(imageMovie.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
}




