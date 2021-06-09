//
//  ViewController.swift
//  iQuiz
//
//  Created by Lei Ryan on 5/7/21.
//

import UIKit
import SystemConfiguration

class Quiz {
    var question: String
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
    var correctAnswer: Int
    init(questionText: String, choiceA: String, choiceB: String, choiceC: String, choiceD: String, answer: Int) {
        question = questionText
        optionA = choiceA
        optionB = choiceB
        optionC = choiceC
        optionD = choiceD
        correctAnswer = answer
    }
}

class QuizType {
    var title : String
    var description : String
    var quiz : [Quiz]
    init(title tl : String, description des : String, q : [Quiz]) {
        title = tl
        description = des
        quiz = q
    }
}


class QuizRepository {
    let urlString = "https://tednewardsandbox.site44.com/questions.json"
    var quizzes : [QuizType] = []
    //task.resume()
    func readLocalFile(forName name: String) -> Data? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {var fileURL = url.appendingPathComponent(name)
                    fileURL = fileURL.appendingPathExtension("json")
            do {
                let data = try Data(contentsOf: fileURL)
                return data
            } catch {
                print("Not Local File Find")
            }
        }
        return nil
    }
        

    func parse(jsonData: Data) -> [QuizType] {
        
        do {
            let questions = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            let y = questions as! Array<Dictionary<String, Any>>
            for i in y {
                let desc = i["desc"] as! String
                let tl = i["title"] as! String
                let question_dict = i["questions"] as! Array<Dictionary<String, Any>>
                var quiz : [Quiz] = []
                for j in question_dict {
                    let question = j["text"] as! String
                    let answer = Int(j["answer"] as! String) ?? 0
                    let option = j["answers"] as! Array<String>
                    quiz.append(Quiz(questionText: question, choiceA: option[0], choiceB: option[1], choiceC: option[2], choiceD: option[3], answer: answer))
                }
                quizzes.append(QuizType(title: tl, description: desc, q : quiz))
            }
            return quizzes
        } catch { print("Error") }
        return quizzes

    }

    func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    func save(jsonString : Data) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory = documentDirectory.first {
            var pathWithFileName = documentDirectory.appendingPathComponent("myJsonData")
            pathWithFileName = pathWithFileName.appendingPathExtension("json")
            do {
                try jsonString.write(to: pathWithFileName)
            } catch {
                print("Unable to save file")
            }
        }
    }
    
    static let instances = QuizRepository()
    
    private init() {}
    
    func allQuizzes() -> [QuizType] {
        
        loadJson(fromURLString: urlString) { (result) in
                switch result {
                case .success(let data):
                    self.save(jsonString: data)
                    
                case .failure(let error):
                    print(error)
                }
        }
     
        let local = self.readLocalFile(forName: "myJsonData")
        let backup = self.readLocalFile(forName: "backup")
        quizzes = parse(jsonData: (local ?? backup)!)
        //quizzes = parse(jsonData: local!)
        return quizzes;
    }
    
    
    
}

class NamesSource : NSObject, UITableViewDataSource {
    static let CELL_STYLE = "BasicStyle"
    let quiz = QuizRepository.instances.allQuizzes()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NamesSource.CELL_STYLE, for:indexPath)
        
        let rows = quiz[indexPath.row]
        cell.textLabel?.text = rows.title
        cell.detailTextLabel?.text = rows.description
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

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}


class ViewController: UIViewController, UITableViewDelegate {
    
    var url = "http://tednewardsandbox.site44.com/questions.json"
    
    @IBOutlet weak var settingButton: UIButton!
    
    
    @objc func triggerAlert(sender: UIButton) {
        let alert = UIAlertController(title: "Settings", message: url, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Check Now", comment: "Default action"), style: .default, handler: { _ in
            QuizRepository.instances.loadJson(fromURLString: self.url) { (result) in
                    switch result {
                    case .success(let data):
                        QuizRepository.instances.save(jsonString: data)
                    case .failure(let error):
                        print(error)
                    }
            }
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
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            let alert = UIAlertController(title: "Network", message: "Your Network is Currently Unavailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print("Internet Connection not Available!")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        NSLog("User selected \(didSelectRowAt)")
        performSegue(withIdentifier: "goquestion", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let quizData = QuizRepository.instances.allQuizzes()
            if let destination = segue.destination as? QuizViewController {
                destination.data = quizData[(tableView.indexPathForSelectedRow?.row)!].quiz
                destination.qnumber = 0
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}

