//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Lei Ryan on 5/19/21.
//

import UIKit

class AnswerViewController: UIViewController {

    var choice : String = ""
    var correct : Bool = false
    var finishNum : Int = 0
    var currentNum : Int = 0
    var questionText : String = ""
    var correctNum : Int = 0
    @IBOutlet weak var thequestion: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var nextOne: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        nextOne.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
    }
    

    
    @objc func backAction(_ sender: UIButton) {
        //print(currentNum)
        //print(finishNum)
        print(currentNum)
        if currentNum <= finishNum {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if currentNum > finishNum {
                return true
        }
        return false
    }
    
    
    
    func updateUI(){
        thequestion.text = "Question: \(questionText)"
        answer.text = "The Correct Answer Is: \(choice)"
        if correct {
            result.text = "Great! You Got It Right!"
        } else {
            result.text = "Sorry, You Got It Wrong!"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? FinishViewController {
                destination.total = finishNum
                destination.correct = correctNum
                
        }
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
