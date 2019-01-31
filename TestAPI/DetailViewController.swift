import UIKit

class DetailViewController: UIViewController {

    var post: Post? {
        didSet {
            guard let body = post?.body, let da = post?.da, let dm = post?.dm else { return }
            bodyLabel.text = body
            createLabel.text = "Созд. " + da
            updateLabel.text = "Изм. " + dm
            updateLabel.isHidden = post?.da == post?.dm
        }
    }
    
    private let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    private let updateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lbl
    }()
    
    private let createLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Полная запись"
        view.backgroundColor = .white
        
        view.addSubview(createLabel)
        view.addSubview(updateLabel)
        view.addSubview(bodyLabel)
        
        setConstraint()
    }
    
    private func setConstraint() {
        createLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        updateLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 30)
        bodyLabel.anchor(top: createLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        bodyLabel.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 10).isActive = true
    }
    
}
