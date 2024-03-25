//
//  MainViewController.swift
//  IMDb
//
//  Created by Aneli  on 11.01.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let collectionViewWidth: CGFloat = 150
    }
    
    // MARK: - Properties
    
    private var networkManager = NetworkManagerAF.shared
    private var titleLabelYPosition: Constraint!
    private var titleLabelXPosition: Constraint!
    private var allMovies: [Result] = []
    private var themes = Themes.allCases
    
    private lazy var movie: [Result] = [] {
        didSet {
            self.movieTableView.reloadData()
        }
    }
    private lazy var genres: [Genre] = [.init(id: 1, name: "All")] {
        didSet {
            self.genresCollectionView.reloadData()
        }
    }
    
    private let containerView = UIView()
    private var genresCollectionViewHeightConstraint: Constraint?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieDB"
        label.alpha = 0
        label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        return label
    }()
    
    private lazy var movieTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    private lazy var themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var hideShowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleGenresTap), for: .touchUpInside)
        containerView.addSubview(button)
        return button
    }()
    
    private lazy var themesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        return collectionView
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Genre"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        return collectionView
    }()
    
    private lazy var containerViewLayoutGuide: UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        containerView.addLayoutGuide(layoutGuide)
        return layoutGuide
    }()
    
    private var movieTableViewTopConstraint: Constraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadGenres()
        loadMovies(theme: .nowPlaying)
        
        if let customArrowImage = UIImage(named: "arrowImageView") {
            hideShowButton.setImage(customArrowImage, for: .highlighted)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    // MARK: - Private Methods
    
    private func animate() {
        UIView.animateKeyframes(withDuration: 2.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.titleLabel.alpha = 1
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
                self.invokeAnimatedTitleLabelUp()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                self.containerView.alpha = 1
            }
            
        }, completion: nil)
    }
    
    private func invokeAnimatedTitleLabelUp() {
        titleLabelYPosition.update(offset: -(view.safeAreaLayoutGuide.layoutFrame.size.height / 2 - 16))
        view.layoutSubviews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        containerView.alpha = 0
        
        [titleLabel, containerView].forEach {
            view.addSubview($0)
        }
        
        [themeLabel,
         themesCollectionView,
         genreLabel,
         hideShowButton,
         genresCollectionView,
         movieTableView].forEach {
            containerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            titleLabelXPosition = make.centerX.equalToSuperview().constraint
            titleLabelYPosition = make.centerY.equalToSuperview().constraint
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(4)
            make.left.equalToSuperview().offset(16)
        }
        
        themesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(themesCollectionView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        
        hideShowButton.snp.makeConstraints { make in
            make.left.equalTo(genreLabel.snp.right).offset(8)
            make.centerY.equalTo(genreLabel)
            make.width.height.equalTo(24)
        }
        
        genresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(genresCollectionView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func updateTableViewTopConstraint() {
        let topConstraint: ConstraintItem
        if genresCollectionView.isHidden {
            topConstraint = genreLabel.snp.bottom
        } else {
            topConstraint = genresCollectionView.snp.bottom
        }
        
        movieTableView.snp.remakeConstraints { make in
            make.top.equalTo(topConstraint).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func handleGenresTap() {
        genresCollectionView.isHidden.toggle()
        genresCollectionViewHeightConstraint?.update(offset: genresCollectionView.isHidden ? 0 : 35)
        updateTableViewTopConstraint()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        let arrowImageName = genresCollectionView.isHidden ? "chevron.down" : "chevron.up"
        if let arrowImage = UIImage(systemName: arrowImageName) {
            hideShowButton.setImage(arrowImage, for: .normal)
            hideShowButton.setTitleColor(.black, for: .highlighted)
            hideShowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    private func loadData() {
        networkManager.loadGenres { [weak self] genres in
            genres.forEach { genre in
                self?.genres.append(genre)
            }
        }
        networkManager.loadMovies(theme: Themes.nowPlaying.urlPath) { [weak self] movies in
            self?.allMovies = movies
            self?.movie = movies
        }
    }
    
    private func loadMovies(theme: Themes) {
        networkManager.loadMovies(theme: theme.urlPath) { [weak self] movies in
            self?.allMovies = movies
            self?.movie = movies
            self?.movieTableView.reloadData()
        }
    }
    
    private func loadGenres() {
        networkManager.loadGenres { [weak self] genres in
            genres.forEach { genre in
                self?.genres.append(genre)
            }
        }
    }
    
    private func obtainMovieList(with genreId: Int) {
        guard genreId != 1 else {
            movie = allMovies
            return
        }
        
        movie = allMovies.filter { movie in
            movie.genreIDS.contains(genreId)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        let movie = movie[indexPath.row]
        cell.configure(with: movie.title, and: movie.posterPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsController = MovieDetailsViewController()
        let movie = movie[indexPath.row]
        movieDetailsController.movieId = movie.id
        navigationController?.pushViewController(movieDetailsController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == themesCollectionView {
            return themes.count
        } else {
            return genres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        if collectionView == themesCollectionView {
            cell.configure(with: themes[indexPath.row].key)
        } else {
            cell.configure(with: genres[indexPath.row].name)
        }
        cell.configureCustomTitle(with: UIFont.systemFont(ofSize: 14))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionViewWidth, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == themesCollectionView {
            let selectedTheme = themes[indexPath.row]
            loadMovies(theme: selectedTheme)
        } else {
            obtainMovieList(with: genres[indexPath.row].id)
        }
    }
}


