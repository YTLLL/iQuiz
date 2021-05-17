//
//  ViewController.swift
//  iQuiz
//
//  Created by Lei Ryan on 5/7/21.
//

import UIKit

class Quiz {
    var title : String
    var description : String
    var question: String
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
    var correctAnswer: Int
    init(title tl : String, description des : String, questionText: String, choiceA: String, choiceB: String, choiceC: String, choiceD: String, answer: Int) {
        title = tl
        description = des
        question = questionText
        optionA = choiceA
        optionB = choiceB
        optionC = choiceC
        optionD = choiceD
        correctAnswer = answer
    }
}

class QuizRepository {
    let url = URL(string: "http://tednewardsandbox.site44.com/questions.json")
    static let task = URLSession.shared.dataTask(with: URL(string: "http://tednewardsandbox.site44.com/questions.json")!) { data, response, error in
        print("We got data back!")
        print((response as! HTTPURLResponse).statusCode)
        
        print(data)
        do {
            let questions = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print((questions as! Array)[0])
        }
        catch { print("Error") }
    }
    
    //task.resume()
    
    static let quizzes = [
        Quiz(title: "Science!", description: "Because SCIENCE!"),
        Quiz(title: "Marvel Super Heroes", description: "How much do you know about heroes?"),
        Quiz(title: "Science", description: "Test science topic")
    ]
    
    static let instances = QuizRepository()
    
    private init() {}
    
    func allQuizzes() -> [Quiz] {
        return QuizRepository.quizzes;
    }
    
    
    
}

class NamesSource : NSObject, UITableViewDataSource {
    static let CELL_STYLE = "BasicStyle"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuizRepository.instances.allQuizzes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NamesSource.CELL_STYLE, for:indexPath)
        
        let quiz = QuizRepository.instances.allQuizzes()[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.description
        
        return cell
    }
    //let names = ["Mathematics", "Marvel Super Heroes", "Science"]
}

class NameSelector : NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        NSLog("User selected \(didSelectRowAt)")
        tableView.deselectRow(at: didSelectRowAt, animated: true)
    }
    
    /*fromViewController.performSegue(withIdentifier: "goquestion", sender: fromViewController)*/
}


class ViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var settingButton: UIButton!
    
    
    @objc func triggerAlert(sender: UIButton) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    let data = NamesSource()
    let actor = NameSelector()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = data
        tableView.delegate = self
        settingButton.addTarget(self, action: #selector(triggerAlert), for: UIControl.Event.touchUpInside)
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        NSLog("User selected \(didSelectRowAt)")
        tableView.deselectRow(at: didSelectRowAt, animated: true)
        performSegue(withIdentifier: "goquestion", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? QuizViewController {
                destination.product = productArray[(tblAppleProducts.indexPathForSelectedRow?.row)!]
                tblAppleProducts.deselectRow(at: tblAppleProducts.indexPathForSelectedRow!, animated: true)
        }
    }
    
}

