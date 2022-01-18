//
//  DetailViewController.swift
//  TMDB
//
//  Created by BS236 on 6/1/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        backgroundBlurEffect()
        
        getMoviePoster()
        setMovieDataToView()
    }
    
    
    func getMoviePoster() {
        guard let posterPath = movie?.poster_path else {
            return
        }
        
        //again fetching movie poster image. This could be improved with setiing the image from the cell when pushing the vc
        APIService.API.getMoviePoster(posterPath){
            [weak self] posterData in
            DispatchQueue.main.async {
                self?.backGroundImageView.image = UIImage(data: posterData)
                self?.posterImageView.image = UIImage(data: posterData)
            }
        }
    }
    
    
    func setMovieDataToView() {
        guard let movie = movie else {
            return
        }
        
        nameLabel.text = movie.title
        releaseDateLabel.text = movie.release_date
        descriptionLabel.text = movie.overview
        popularityLabel.text = movie.popularity.string
        ratingLabel.text = movie.vote_average.string
        votesLabel.text = movie.vote_count.string
    }
    
    
    func backgroundBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
    }
}


