import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // When session recieved
        let isSessionRecieved = UserDefaults.standard.bool(forKey: "isSessionRecieved")
        if !isSessionRecieved  {
            getNewSession()
        } else {
           fetchPost()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "updateTable"), object: nil, queue: OperationQueue.main) { (_) in
            self.fetchPost()
        }
        
        title = "Список записей"
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnHandler))
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "post")
    }
    
    @objc func addBtnHandler() {
        let addVC = AddViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }

    private func getNewSession() {
        let params = [ "a" : "new_session" ]
        let headers: HTTPHeaders = [ "token" : API.Token ]
        
        request(API.BaseURL, method: .post, parameters: params, headers: headers).responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                // Check response status
                if jsonResponse["status"].intValue == 1 {
                    let session = jsonResponse["data"]["session"].stringValue
                    UserDefaults.standard.set(session, forKey: "session")
                    UserDefaults.standard.set(true, forKey: "isSessionRecieved")
                    print("Session Recieved")
                } else {
                    Alert.showAlert(onVC: self, actionTapped: {
                        self.getNewSession()
                    })
                }
            case .failure:
                Alert.showAlert(onVC: self, actionTapped: {
                    self.getNewSession()
                })
            }
        }
    }
    
    private func fetchPost() {
        let params = [ "a": "get_entries", "session" : API.Session]
        let headers: HTTPHeaders = ["token" : API.Token]
        request(API.BaseURL, method: .post, parameters: params, headers: headers).responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                if jsonResponse["status"].intValue == 1 {
                    let posts = jsonResponse["data"][0]
                    self.posts = []
                    posts.array?.forEach({ (post) in
                        let convertedCreateDate = self.convertDate(date: post["da"].stringValue)
                        let convertedUpdateDate = self.convertDate(date: post["dm"].stringValue)
                        let post = Post.init(da: convertedCreateDate, dm: convertedUpdateDate, body: post["body"].stringValue)
                        self.posts.append(post)
                    })
                    print("succes fetched")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    Alert.showAlert(onVC: self, actionTapped: {
                        self.fetchPost()
                    })
                }
            case .failure:
                Alert.showAlert(onVC: self, actionTapped: {
                    self.fetchPost()
                })
            }
        }
    }

    private func convertDate(date: String) -> String {
        guard let dateInt = Int(date) else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! TableViewCell
        cell.post = posts[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.post = posts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
