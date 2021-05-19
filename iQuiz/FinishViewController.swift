//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Lei Ryan on 5/19/21.
//

import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var desctext: UILabel!
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var backBnt: UINavigationItem!
    
    var correct : Int = 0
    var total : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
            _ = navigationController?.popToRootViewController(animated: false)
        }
    
    func updateUI(){
        if correct == total {
            desctext.text = "Perfect! You Got Full Scores!"
        } else {
            desctext.text = "Almost! You Can Always Try Again!"
        }
        score.text = "You Got \(correct) Out Of \(total) Correct!"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
