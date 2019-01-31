import UIKit

class TableViewCell: UITableViewCell {

    var post: Post? {
        didSet {
            guard let body = post?.body, let da = post?.da, let dm = post?.dm else { return }
            let bodyText = body.count > 200 ? body.prefix(200) + "..." : body
            bodyLabel.text = bodyText
            createLabel.text = "Созд. " + da
            updateLabel.text = "Изм. " + dm
            updateLabel.isHidden = post?.da == post?.dm
        }
    }
    
    private let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let createLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lbl
    }()
    
    private let updateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bodyLabel)
        contentView.addSubview(createLabel)
        contentView.addSubview(updateLabel)
        
        createLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        updateLabel.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        bodyLabel.anchor(top: createLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: -10, paddingRight: 20, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
