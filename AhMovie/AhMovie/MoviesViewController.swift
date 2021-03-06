//
//  ViewController.swift
//  AhMovie
//
//  Created by TK Nguyen on 6/16/17.
//  Copyright © 2017 tknguyen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import SystemConfiguration
import Foundation

class MoviesViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var searchbar = UISearchBar()
    var segmentControl = UISegmentedControl()
    var url_nowplaying: URL?
    var url_toprated: URL?
    var movies = [[String:Any]]()
    let baseUrl = "http://image.tmdb.org/t/p/w500"
    var selectedUrl = ""
    var selectedOverview = ""
    var selectedtitleLabel = ""
    var selecteddateLabel = ""
    var selectedVote : Double = 0.0
    var refreshControl = UIRefreshControl()
    var isNowPlaying: Bool?
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         MBProgressHUD.showAdded(to: tableView, animated: true)
        
        
        
        url_nowplaying = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
        url_toprated = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
        fetchData()
        
        tableView.dataSource = self
        tableView.delegate =  self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh!!!")
        refreshControl.addTarget(self, action: #selector(MoviesViewController.fetchData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        //TODO: Segment
        segmentControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        
        
        segmentControl.insertSegment(with: UIImage(named: "list_view"), at: 0, animated: true)
        
        segmentControl.insertSegment(with: UIImage(named: "grid_view"), at: 1, animated: true)
        
        segmentControl.backgroundColor = UIColor.white
        
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.addTarget(self, action: #selector(MoviesViewController.segment(sender:)), for: UIControlEvents.valueChanged )

        let rightBut = UIBarButtonItem()
        rightBut.customView = segmentControl
        self.navigationItem.rightBarButtonItem = rightBut
        
        
        collectionView.isHidden = true
        
        
//
//        let rightbut = UIBarButtonItem()
//        rightbut.customView = segmentControl
//        
//        
//        self.navigationItem.rightBarButtonItem = rightbut
        
        
        //TODO: Search bar
//        searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
//        searchbar.placeholder = "Search"
//        searchbar.showsCancelButton = true
//        self.navigationItem.titleView = searchbar
//        MBProgressHUD.hide(for: self.view, animated: true)
//        
        
        
        //TODO: Don't need it ---> remove later
        if isInternetAvailable() == false {
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
         MBProgressHUD.hide(for: self.tableView, animated: true)
    }
    
    func segment(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func fetchData() {
        if isInternetAvailable() {
            var url_endpoint = url_toprated
            if isNowPlaying == true {
                url_endpoint = url_nowplaying
            }
            
            if let url = url_endpoint {
                let request = URLRequest(
                    url: url,
                    cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                    timeoutInterval: 10)
                let session = URLSession(
                    configuration: URLSessionConfiguration.default,
                    delegate: nil,
                    delegateQueue: OperationQueue.main)
                let task = session.dataTask(
                    with: request,
                    completionHandler: { (dataOrNil, response, error) in
                        if let data = dataOrNil {
                            if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                //                            print("response: \(responseDictionary)")
                                if let moviesData = responseDictionary["results"] as? [[String:Any]] {
                                    //                                for movie in moviesData{
                                    //                                    if let name = movie["original_title"] as? String {
                                    //                                        print(name)
                                    //                                    }
                                    //                                }
                                    self.movies = moviesData
                                    self.tableView.reloadData()
                                    self.collectionView.reloadData()
                                    self.refreshControl.endRefreshing()
                                }
                            }
                        }
                })
                task.resume()
            }
            
        }
        else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.tk.MovieCollectionCell", for: indexPath) as! MoviesCollectionViewCell
        
        let imgUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        cell.PosterImage.setImageWith(NSURL(string: imgUrl)! as URL)
        
        
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.tk.MoviePrototypeCell", for: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]["original_title"] as! String
        let desc = movies[indexPath.row]["overview"] as! String
        let imgUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        
        cell.MovieImageView.setImageWith(NSURL(string: imgUrl)! as URL)
        cell.TitleLabel.text = movie
        cell.DescriptionLabel.text = desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let nextViewController = segue.destination as! MovieDetailsViewController
        
        nextViewController.imgUrl = selectedUrl
        nextViewController.selectedOverview = selectedOverview
        nextViewController.selectedtitleLabel = selectedtitleLabel
        nextViewController.selecteddateLabel = selecteddateLabel
        nextViewController.selectedVote = selectedVote
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        selectedOverview = movies[indexPath.row]["overview"] as! String
        selectedtitleLabel = movies[indexPath.row]["title"] as! String
        selecteddateLabel = movies[indexPath.row]["release_date"] as! String
        selectedVote = movies[indexPath.row]["vote_average"] as! Double
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        selectedOverview = movies[indexPath.row]["overview"] as! String
        selectedtitleLabel = movies[indexPath.row]["title"] as! String
        selecteddateLabel = movies[indexPath.row]["release_date"] as! String
        selectedVote = movies[indexPath.row]["vote_average"] as! Double
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}







