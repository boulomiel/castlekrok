//
//  ScoreViewController.swift
//  Project_Game
//
//  Created by sruben mimounon 16/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    
    var scoreArray : [Score] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadScores()
        
    }
    
    
    private func loadScores(){
        
        
        FirebaseManager.manager.getAllScores(with: { [weak self](scores) in
            guard let self =  self else {return}
            let sortedScore =  scores.sorted{$0.score > $1.score}
            self.scoreArray = sortedScore
            self.tableView.reloadData()
            
        })
    }
    
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}

extension ScoreViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let score  = scoreArray[indexPath.row]
        let message : String
        if score.score == scoreArray[0].score {
            message = "\n" + "Score : \(score.score)" + "\n Best Score"
        }else{
            message = "\n" + "Score : \(score.score)"
        }        
        showAlert(title: (score.player),message:message)
        
    }
}



extension ScoreViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! HighScoreTableCell
        cell.isHighlighted = false
        let score  = scoreArray[indexPath.row]
        cell.setup(player: score.player, score: "\(score.score)", date: score.date)
        
        return cell
    }
    
    
    
    
    
    
    
}
