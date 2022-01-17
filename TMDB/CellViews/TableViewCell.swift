//
//  TableViewCell.swift
//  TMDB
//
//  Created by BS236 on 10/1/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    var genreId: Int?
    var movieList = [Movie]()
    var parent: UIViewController?
    var totalPage = 1
    var pageCount = 2
    var fetching = false
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //delegating
        collView.delegate = self
        collView.dataSource = self
        
        getMovieData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //fetching movie collection and the data from 1st page of the api
    func getMovieData(){
        guard let genreId = genreId else {
            return
        }
        APIService.API.getMoviesByGenre(genreId){
            [weak self] jsonPayload in
            DispatchQueue.main.async {
                self?.totalPage = jsonPayload.total_pages
                self?.movieList = jsonPayload.results
                self?.collView.reloadData()
            }
        }
    }
    
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //setting fetching to false 5 index before the end so that the scrollviewdidscroll is ready for fetching
        if (indexPath.row == movieList.count-5){
            self.fetching = false
        }
        
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! CollectionViewCell
        let movie = movieList[indexPath.row]
        
        guard let posterPath = movie.poster_path else {
            return cell
        }
        
        //fetching poster image
        APIService.API.getMoviePoster(posterPath){
            posterData in
            DispatchQueue.main.async {
                cell.imgView.image = UIImage(data: posterData)
            }
        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //pushing detail view when selected
        if let vc = storyboard.instantiateViewController(withIdentifier: "details") as? DetailViewController {
            vc.movie.append(movieList[indexPath.row])
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        
        //print("lhs: \(offsetX) > rhs: \(contentWidth - scrollView.frame.width)")
        
        //we only call the api when we are near the end of the scroll view
        if offsetX > contentWidth - scrollView.frame.width - 100{
            //checking if we are already fetching any data or not
            if !fetching {
                self.fetching = true
                print("api calling with page \(pageCount) | OffsetX: \(offsetX)")
                self.fetchData()
            }
        }
    }
    
    func fetchData() {
        if pageCount <= totalPage {
            guard let genreId = genreId else {
                return
            }
            
            //calling api with pagination
            APIService.API.getMoviesByPage(genreId, pageCount){
                [weak self] jsonPayload in
                DispatchQueue.main.async {
                    self?.movieList.append(contentsOf: jsonPayload.results)
                    self?.collView.reloadData()
                }
            }
            
            self.pageCount += 1
        }
    }
    
}
