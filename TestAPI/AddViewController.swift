import UIKit
import Alamofire
import SwiftyJSON

class AddViewController: UIViewController {

    private var textView: UITextView = {
        let lbl = UITextView()
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    private var okBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(sendPost))
        item.isEnabled = false
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Создание записи"
        view.backgroundColor = .white
        
        addTextField()
        textView.delegate = self
        textView.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem = okBtn
    }

    @objc func sendPost() {
        guard let text = textView.text else { return }
        let trimmingText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let params: [String: Any] = [
            "a": "add_entry",
            "session": API.Session,
            "body": trimmingText
        ]
        let headers: HTTPHeaders = [ "token" : API.Token]
        
        request(API.BaseURL, method: .post, parameters: params, headers: headers).responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                if jsonResponse["status"].intValue == 1 {
                    print("Success add")
                } else {
                    Alert.showAlert(onVC: self, actionTapped: {
                        self.sendPost()
                    })
                }
            case .failure:
                Alert.showAlert(onVC: self, actionTapped: {
                    self.sendPost()
                })
            }
        }
        
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
    }
        
    private func addTextField() {
        view.addSubview(textView)
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
    }
}

extension AddViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        okBtn.isEnabled = !textView.text.isEmpty
    }
}

