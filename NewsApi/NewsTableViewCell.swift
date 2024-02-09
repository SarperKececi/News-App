import UIKit

class NewsTableViewCellViewModel {
    var title: String
    var subtitle: String
    var imageURL: URL?
    var imageData: Data?
    
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageWidth: CGFloat = 100
        let padding: CGFloat = 10

        newsImageView.frame = CGRect(
            x: contentView.bounds.width - imageWidth - padding,
            y: padding,
            width: imageWidth,
            height: contentView.bounds.height - 2 * padding
        )

        let labelWidth = contentView.bounds.width - imageWidth - (padding * 3)
        newsTitleLabel.frame = CGRect(
            x: padding,
            y: padding,
            width: labelWidth,
            height: (contentView.bounds.height / 2) - padding
        )

        subTitleLabel.frame = CGRect(
            x: padding,
            y: (contentView.bounds.height / 2) + padding,
            width: labelWidth,
            height: (contentView.bounds.height / 2) - padding
        )
    }

    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else {
            if let url = viewModel.imageURL {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    viewModel.imageData = data
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
}
