//
//  QuizViewController.swift
//  iQuiz
//
//  Created by Lei Ryan on 5/17/21.
//

import UIKit

class QuizViewController: UIViewController {

    var data : [Quiz]?
    @IBOutlet weak var quesiton: UILabel!

    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    var qnumber : Int = 0
    var count : Int = 1
    var correct : Bool = false
    var choiceText : String = ""
    var currentQ : String = ""
    var correctNum : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateQuestion()
        // Do any additional setup after loading the view.
    }
    
    func updateQuestion(){
        quesiton.text = data![qnumber].question
        optionA.setTitle(data![qnumber].optionA, for: UIControl.State.normal)
        optionB.setTitle(data![qnumber].optionB, for: UIControl.State.normal)
        optionC.setTitle(data![qnumber].optionC, for: UIControl.State.normal)
        optionD.setTitle(data![qnumber].optionD, for: UIControl.State.normal)
    }
    
    
    @IBAction func answerPressed(_ sender: UIButton) {
        currentQ = data![qnumber].question
        if data![qnumber].correctAnswer == 1 {
            choiceText = data![qnumber].optionA
        } else if data![qnumber].correctAnswer == 2 {
            choiceText = data![qnumber].optionB
        } else if data![qnumber].correctAnswer == 3 {
            choiceText = data![qnumber].optionC
        } else {
            choiceText = data![qnumber].optionD
        }
        if sender.tag == data![qnumber].correctAnswer {
            correct = true
            correctNum += 1
        }else{
            correct = false
        }
        
        if count <= (data!.count){
            count += 1
        }
        if qnumber < (data!.count - 1) {
            qnumber += 1
        }
        updateQuestion()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? AnswerViewController {
                destination.choice = choiceText
                destination.correct = correct
                destination.questionText = currentQ
                destination.currentNum = count
                destination.finishNum = data!.count
                destination.correctNum = correctNum
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
