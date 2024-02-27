//
//  MovieDetailsMainViewController.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {

    private enum Constants {
        static let spacingBetweenLabelsAndCollectionView: CGFloat = 8
    }
    
    // MARK: - Properties
    
    var movieId: Int?
    private let networkManager = NetworkManagerAF.shared
    private var voteAverage: Int = 0
    private var genres: [Genre] = [] {
        didSet {
            self.genresCollectionView.reloadData()
        }
    }
    private var castMembers: [CastElement] = [] {
        didSet {
            self.castCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        return container
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        return collectionView
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var voteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var starsStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    private lazy var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Overview"
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "Overview"
        return label
    }()
    
    private lazy var castTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Cast"
        return label
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var linkTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Link"
        return label
    }()
    
    private lazy var youtubeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_youtube"), for: .normal)
        button.addTarget(self, action: #selector(openYouTube), for: .touchUpInside)
        return button
    }()
    
    private lazy var imdbButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_imdb"), for: .normal)
        button.addTarget(self, action: #selector(openIMDb), for: .touchUpInside)
        return button
    }()
    
    private lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_fcb"), for: .normal)
        button.addTarget(self, action: #selector(openFacebook), for: .touchUpInside)
        return button
    }()
    
    private let youtubeURLString = "https://www.youtube.com/watch?v="
    private let imdbURLString = "https://www.imdb.com/"
    private let facebookURLString = "https://www.facebook.com/"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        loadMovieDetails()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        self.title = "Movie"
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [movieImageView,
         titleLabel,
         releaseDateLabel,
         genresCollectionView,
         voteLabel,
         starsStack,
         overviewTitleLabel,
         overviewLabel,
         castTitleLabel,
         castCollectionView,
         linkTitleLabel,
         youtubeButton,
         imdbButton,
         facebookButton
        ].forEach {
            containerView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.bottom.equalTo(facebookButton.snp.bottom).offset(20)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(24)
            make.centerX.equalTo(containerView)
            make.width.equalTo(309)
            make.height.equalTo(424)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(genresCollectionView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(24)
            make.width.equalTo(120)
            make.height.equalTo(39.5)
        }
        
        genresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(starsStack.snp.left).offset(-16)
            make.height.equalTo(35)
        }
        
        starsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(39.5)
            make.width.equalTo(120)
        }
        
        voteLabel.snp.makeConstraints { make in
            make.top.equalTo(starsStack.snp.bottom).offset(16)
            make.centerX.equalTo(starsStack)
            make.width.equalTo(120)
            make.height.equalTo(39.5)
        }
        
        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(voteLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(containerView).inset(24)
        }
        
        castTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castTitleLabel.snp.bottom).offset(Constants.spacingBetweenLabelsAndCollectionView)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        linkTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollectionView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        youtubeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-70)
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(20)
            make.width.height.equalTo(50)
            make.bottom.equalToSuperview().inset(24)
        }
        
        imdbButton.snp.makeConstraints { make in
            make.centerY.equalTo(youtubeButton)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        facebookButton.snp.makeConstraints { make in
            make.centerY.equalTo(youtubeButton)
            make.centerX.equalToSuperview().offset(70)
            make.width.height.equalTo(50)
        }
    }
    
    private func loadMovieDetails() {
        guard let movieId = movieId else { return }
        networkManager.loadMovieDetails(id: movieId) { [weak self] movieDetails in
            guard let self = self else { return }
            self.titleLabel.text = movieDetails.originalTitle ?? ""
            self.overviewLabel.text = movieDetails.overview ?? ""
            if let voteAverage = movieDetails.voteAverage {
                self.voteLabel.text = "Rating: \(voteAverage)"
                self.voteAverage = Int(voteAverage)
                self.createStarsStack()
            }
            self.genres = movieDetails.genres
            if let releaseDate = movieDetails.releaseDate {
                self.releaseDateLabel.text = "Release date: \(releaseDate)"
            }
            if let backdropPath = movieDetails.posterPath {
                let urlString = "https://image.tmdb.org/t/p/original" + backdropPath
                let url = URL(string: urlString)!
                self.movieImageView.kf.setImage(with: url)
            }
            self.loadCastMembers(for: movieId)
        }
    }
    
    private func createStarsStack() {
        let voteAverageDouble: Double = Double(voteAverage)
        let voteFullStars: Int = Int(voteAverageDouble / 2)
        let hasHalfStar: Bool = voteAverageDouble.truncatingRemainder(dividingBy: 2) != 0
        
        for _ in 0..<voteFullStars {
            let fullStarImageView = UIImageView()
            fullStarImageView.contentMode = .scaleToFill
            fullStarImageView.image = UIImage(named: "full_star")
            fullStarImageView.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(17)
            }
            starsStack.addArrangedSubview(fullStarImageView)
        }
        
        if hasHalfStar {
            let halfStarImageView = UIImageView()
            halfStarImageView.contentMode = .scaleToFill
            halfStarImageView.image = UIImage(named: "half_star")
            halfStarImageView.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(17)
            }
            starsStack.addArrangedSubview(halfStarImageView)
        }
        
        let leftEmptyStars: Int = 5 - voteFullStars - (hasHalfStar ? 1 : 0)
        for _ in 0..<leftEmptyStars {
            let emptyStarImageView = UIImageView()
            emptyStarImageView.contentMode = .scaleToFill
            emptyStarImageView.image = UIImage(named: "empty_star")
            emptyStarImageView.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(17)
            }
            starsStack.addArrangedSubview(emptyStarImageView)
        }
    }
    
    private func loadCastMembers(for movieId: Int) {
        networkManager.loadCast(movieId: movieId) { [weak self] cast in
            self?.castMembers = cast
        }
    }
    
    // MARK: - Actions
    
    @objc private func openYouTube() {
        DispatchQueue.main.async {
            guard let youtubeURL = URL(string: self.youtubeURLString) else { return }
            UIApplication.shared.open(youtubeURL)
        }
    }
    
    @objc private func openIMDb() {
        DispatchQueue.main.async {
            guard let imdbURL = URL(string: self.imdbURLString) else { return }
            UIApplication.shared.open(imdbURL)
        }
    }
    
    @objc private func openFacebook() {
        DispatchQueue.main.async {
            guard let facebookURL = URL(string: self.facebookURLString) else { return }
            UIApplication.shared.open(facebookURL)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genresCollectionView {
            return genres.count
        } else if collectionView == castCollectionView {
            return castMembers.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genresCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
            let genre = genres[indexPath.item].name
            cell.configureCustomTitle(with: UIFont.systemFont(ofSize: 10))
            cell.configure(with: genre)
            return cell
        } else if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            let castMember = castMembers[indexPath.item]
            cell.configure(with: castMember)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView {
            return CGSize(width: 60, height: 22)
        } else if collectionView == castCollectionView {
            return CGSize(width: 200, height: 80)
        }
        return .zero
    }
}

// MARK: - UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castCollectionView {
            let selectedCastMember = castMembers[indexPath.item]
            showActorDetails(for: selectedCastMember)
        }
    }
    
    func showActorDetails(for castMember: CastElement) {
        NetworkManagerAF.shared.loadActorDetails(actorId: castMember.id) { actorDetails in
            DispatchQueue.main.async {
                
                let actorDetailsVC = ActorDetailsViewController()

                actorDetailsVC.actor = actorDetails

                guard let navigationController = self.navigationController else {
                    print("navigationController не инициализирован")
                    return
                }
                navigationController.pushViewController(actorDetailsVC, animated: true)
            }
        }
    }
}
