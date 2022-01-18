//
//  TableViewCell.swift
//  TMDB
//
//  Created by BS236 on 10/1/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
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
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
                self?.collectionView.reloadData()
            }
        }
    }
    
    func cellConfiguration(genreName: String, genreID: Int){
        selectionStyle = .none
        backgroundColor = UIColor.clear
        titleTextLabel.text = genreName
        genreId = genreID
        
        awakeFromNib()
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? CollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
            return cell
        }
        
        guard let posterPath = movieList[indexPath.row].poster_path else {
            return cell
        }
        
        cell.cellConfiguration(posterPath: posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //pushing detail view when selected
        if let vc = storyboard.instantiateViewController(withIdentifier: "details") as? DetailViewController {
            vc.movie = movieList[indexPath.row]
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        
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
                    self?.collectionView.reloadData()
                }
            }
            
            self.pageCount += 1
        }
    }
    
}
