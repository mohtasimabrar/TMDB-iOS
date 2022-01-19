//
//  CollectionViewCell.swift
//  TMDB
//
//  Created by BS236 on 10/1/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func cellConfiguration(posterPath: String) {
        
        //fetching poster image
        APIService.API.getMoviePoster(posterPath){
            [weak self] posterData in
            
            guard let weakSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                weakSelf.imageView.image = UIImage(data: posterData)
            }
        }
        
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}
