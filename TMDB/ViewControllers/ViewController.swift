//
//  ViewController.swift
//  TMDB
//
//  Created by BS236 on 6/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var genreList = [Genre]()
    var xOffsets: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The Movie Database"
        getGenreList()
    }
    
    //fetching genre list from api
    func getGenreList(){
        APIService.API.getGenreList{
            [weak self] jsonPayload in
            DispatchQueue.main.async {
                self?.genreList = jsonPayload.genres
                self?.tableView.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
        cell.cellConfiguration(genreName: genreList[indexPath.row].name, genreID: genreList[indexPath.row].id)
        cell.parent = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0
    }
    
    
    //these 2 methods are used to keep track of the scroll position of the collection view because dequeue reusable method kept scrolling multiple rows at once
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        xOffsets[indexPath] = (cell as? TableViewCell)?.collectionView.contentOffset.x
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TableViewCell)?.collectionView.contentOffset.x = xOffsets[indexPath] ?? 0
    }
}
