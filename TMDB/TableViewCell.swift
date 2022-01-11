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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collView.delegate = self
        collView.dataSource = self
        guard let genreId = genreId else {
            return
        }

        getMovieData(from: Constants.getMovieCollectionURL(byGenre: genreId ))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getMovieData(from url: String){
        
        //URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!))
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
            (data, response, error) in
            
            var result: MovieCollectionResponse?
            do {
                result = try JSONDecoder().decode(MovieCollectionResponse.self, from: data!)
                guard let json = result else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.movieList = json.results
                    self.collView.reloadData()
                }
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
    }
    
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! CollectionViewCell
        let movie = movieList[indexPath.row]
        
        guard let uri = movie.poster_path else {
            return cell
        }
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: Constants.posterBaseURL + uri)!)) {
            (data, req, error) in
            
            let posterView = data
                
            DispatchQueue.main.async {
                cell.imgView.image = UIImage(data: posterView!)
            }

        }.resume()
        
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
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "details") as? DetailViewController {
            vc.movie.append(movieList[indexPath.row])
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
