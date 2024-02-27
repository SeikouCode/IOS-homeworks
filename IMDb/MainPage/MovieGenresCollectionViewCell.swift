//
//  MovieGenresCollectionViewCell.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//
//
//import UIKit
//
//class MovieGenresCollectionViewCell: UICollectionViewCell {
//    
//    private var title: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with title: String) {
//        self.title.text = title
//    }
//    
//    func configureCustomTitle(with font: UIFont) {
//        self.title.font = font
//    }
//    
//    private func setupViews() {
//        backgroundColor = .blue
//        clipsToBounds = true
//        layer.cornerRadius = 11
//        
//        contentView.addSubview(title)
//        title.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview().inset(4)
//            make.left.right.equalToSuperview().inset(16)
//        }
//    }
//}
