//
//  MovieDetailsViewController.swift
//  AhMovie
//
//  Created by TK Nguyen on 6/19/17.
//  Copyright © 2017 tknguyen. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var overviewLable: UILabel!
    @IBOutlet weak var voteNumLabel: UILabel!
    @IBOutlet weak var releasedateLable: UILabel!
    @IBOutlet weak var TitleLable: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
        var imgUrl = ""
    var selectedUrl = ""
    var selectedOverview = ""
    var selectedtitleLabel = ""
    var selecteddateLabel = ""
    var selectedVote : Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backdropImageView.setImageWith(NSURL(string: imgUrl)! as URL)
        TitleLable.text = selectedtitleLabel
        releasedateLable.text = selecteddateLabel
        voteNumLabel.text = String(selectedVote)
        overviewLable.text = selectedOverview
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
