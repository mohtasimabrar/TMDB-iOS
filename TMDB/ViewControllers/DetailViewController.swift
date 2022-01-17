//
//  DetailViewController.swift
//  TMDB
//
//  Created by BS236 on 6/1/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var relDate: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var votes: UILabel!
    
    var movie = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
        
        guard let posterPath = movie[0].poster_path else {
            return
        }
        
        //again fetching movie poster image. This could be improved with setiing the image from the cell when pushing the vc
        APIService.API.getMoviePoster(posterPath){
            [weak self] posterData in
            DispatchQueue.main.async {
                self?.bg.image = UIImage(data: posterData)
                self?.poster.image = UIImage(data: posterData)
            }
        }
        
        name.text = movie[0].title
        relDate.text = movie[0].release_date
        des.text = movie[0].overview
        popularity.text = movie[0].popularity.string
        rating.text = movie[0].vote_average.string
        votes.text = movie[0].vote_count.string
        
    }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
