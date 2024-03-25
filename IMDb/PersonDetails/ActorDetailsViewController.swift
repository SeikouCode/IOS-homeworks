//
//  ActorDetailsViewController.swift
//  IMDb
//
//  Created by Aneli  on 17.02.2024.
//

import UIKit
import Kingfisher
import Alamofire

class ActorDetailsViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    var actor: ActorDetailsModel?
    private var actorPhotos: [Profile] = []
    private var actorMovies: [Result] = []
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        return container
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var placeOfBirthLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var biographyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Bio"
        return label
    }()
    
    private lazy var biographyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var photoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Photo"
        return label
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 63, height: 107)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collectionView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Movie"
        return label
    }()
    
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 63, height: 107)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ActorMovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()

    private lazy var linkTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Link"
        return label
    }()
    
    private lazy var imdbButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_imdb"), for: .normal)
        button.addTarget(self, action: #selector(openIMDb), for: .touchUpInside)
        return button
    }()

    
    private lazy var instagramButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_instagram"), for: .normal)
        button.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        loadActorDetails()
        
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        movieCollectionView.register(ActorMovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        self.title = "Actor"
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [profileImageView,
         nameLabel,
         birthdayLabel,
         placeOfBirthLabel,
         biographyTitleLabel,
         biographyLabel,
         photoTitleLabel,
         photoCollectionView,
         movieTitleLabel,
         movieCollectionView,
         linkTitleLabel,
         imdbButton,
         instagramButton
        ].forEach {
            containerView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.bottom.equalTo(instagramButton.snp.bottom).offset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(24)
            make.centerX.equalTo(containerView)
            make.width.equalTo(309)
            make.height.equalTo(424)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.left.right.equalTo(containerView).inset(54)
            make.height.equalTo(58)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.right.equalTo(containerView)
            make.height.equalTo(20)
        }
        
        placeOfBirthLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(8)
            make.left.right.equalTo(containerView)
            make.height.equalTo(20)
        }
        
        biographyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeOfBirthLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        biographyLabel.snp.makeConstraints { make in
            make.top.equalTo(biographyTitleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(containerView).inset(24)
        }
        
        photoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(biographyLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(photoTitleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(containerView)
            make.height.equalTo(120)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(containerView)
            make.height.equalTo(150)
        }
        
        linkTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieCollectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(containerView.snp.bottom).inset(24)
        }
        
        imdbButton.snp.makeConstraints { make in
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-10)
        }

        instagramButton.snp.makeConstraints { make in
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(10)
        }
    }
    
    private func loadActorDetails() {
        guard let actor = actor else { return }
        
        nameLabel.text = actor.name
        biographyLabel.text = actor.biography
        birthdayLabel.text = "Birthday: \(actor.birthday)"
        placeOfBirthLabel.text = "Place of Birth: \(actor.placeOfBirth)"
        
        if let profilePath = actor.profilePath {
            let imageUrlString = "https://image.tmdb.org/t/p/w500\(profilePath)"
            print("URL изображения актера: \(imageUrlString)")
            if let imageUrl = URL(string: imageUrlString) {
                profileImageView.kf.setImage(with: imageUrl)
            } else {
                print("Недопустимый URL изображения: \(imageUrlString)")
                profileImageView.image = UIImage(named: "placeholder")
            }
        } else {
            print("Путь к профилю равен nil")
            profileImageView.image = UIImage(named: "placeholder")
        }
        loadActorPhotos(actorId: actor.id)
        loadActorMovies(actorId: actor.id)
        
        NetworkManagerAF.shared.loadActorExternalIDs(actorId: actor.id) { [weak self] (externalIDs: ExternalIDs?) in
            self?.actor?.externalIDs = externalIDs
        }
    }
    
    private func loadActorPhotos(actorId: Int) {
        NetworkManagerAF.shared.loadActorPhotos(actorId: actorId) { [weak self] (photos: [Profile]) in
            DispatchQueue.main.async {
                self?.actorPhotos = photos
                self?.photoCollectionView.reloadData()
            }
        }
    }
    
    private func loadActorMovies(actorId: Int) {
        NetworkManagerAF.shared.loadMovies(theme: "drama") { [weak self] movies in
            DispatchQueue.main.async {
                self?.actorMovies = movies
            }
        }
    }
    
    @objc private func openIMDb() {
        guard let imdbId = actor?.externalIDs?.imdbId else {
            print("IMDb ID is not available.")
            return
        }
        if let url = URL(string: "https://www.imdb.com/name/\(imdbId)") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func openInstagram() {
        guard let instagramId = actor?.externalIDs?.instagramId else {
            print("Instagram ID is not available.")
            return
        }
        if let url = URL(string: "https://www.instagram.com/\(instagramId)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ActorDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoCollectionView {
            return actorPhotos.count
        } else if collectionView == movieCollectionView {
            return actorMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell

            let imageURL = actorPhotos[indexPath.item].filePath
            print("Photo Image URL: \(imageURL)")
            if let url = URL(string: imageURL) {
                cell.imageView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        cell.imageView.image = UIImage(named: "placeholder")
                    }
                }
            } else {
                cell.imageView.image = UIImage(named: "placeholder")
            }
            
            return cell
        } else if collectionView == movieCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! ActorMovieCollectionViewCell

            cell.titleLabel.text = actorMovies[indexPath.item].title
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}


