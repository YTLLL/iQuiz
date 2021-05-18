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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateQuestion()
        // Do any additional setup after loading the view.
    }
    
    func updateQuestion(){
        quesiton.text = data![0].question
        optionA.setTitle(data![0].optionA, for: UIControl.State.normal)
        optionB.setTitle(data![0].optionB, for: UIControl.State.normal)
        optionC.setTitle(data![0].optionC, for: UIControl.State.normal)
        optionD.setTitle(data![0].optionD, for: UIControl.State.normal)
 
            
        }
    
    @IBAction func answerPressed(_ sender: UIButton) {
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
