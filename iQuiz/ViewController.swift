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
    init(title tl : String, description des : String) {
        title = tl
        description = des
    }
}

class QuizRepository {
    static let quizzes = [
        Quiz(title: "Mathematics", description: "Test your calculation skills"),
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
    }
}


class ViewController: UIViewController {
    
    
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
        settingButton.addTarget(self, action: #selector(triggerAlert), for: UIControl.Event.touchUpInside)
        
    }

    
    
}

