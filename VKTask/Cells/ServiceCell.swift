import Foundation
import UIKit
import Alamofire
import PinLayout

final class ServiceCell: UITableViewCell {
    
    //MARK: Vars
    
    static let reuseId = "ServiceCell"
    
    private let serviceImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chevronImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let serviceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let serviceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var largeWidthConstraint = serviceImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05)
    private lazy var smallWidthConstraint = serviceImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15)
    
    //MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    //MARK: Funcs
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.width < 500 {
            largeWidthConstraint.isActive = false
            smallWidthConstraint.isActive = true
        } else {
            smallWidthConstraint.isActive = false
            largeWidthConstraint.isActive = true
        }
        
    }
    
    override func prepareForReuse() {
        serviceImageView.image = nil
    }
    
    private func addSubviews() {
        addSubview(serviceImageView)
        addSubview(serviceNameLabel)
        addSubview(serviceDescriptionLabel)
        addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            serviceImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            serviceImageView.heightAnchor.constraint(equalTo: serviceImageView.widthAnchor),
            serviceImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            chevronImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
        
        NSLayoutConstraint.activate([
            serviceNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            serviceNameLabel.leadingAnchor.constraint(equalTo: serviceImageView.trailingAnchor, constant: 15),
            serviceNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        ])
        serviceNameLabel.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            serviceDescriptionLabel.leadingAnchor.constraint(equalTo: serviceNameLabel.leadingAnchor),
            serviceDescriptionLabel.topAnchor.constraint(equalTo: serviceNameLabel.bottomAnchor),
            serviceDescriptionLabel.trailingAnchor.constraint(equalTo: serviceNameLabel.trailingAnchor),
            serviceDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        serviceDescriptionLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private func downloadImage(url: URL, completion: @escaping (Data?) -> ()) {
        AF.request(url).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func setup(model: ServiceDisplayModel) {
        serviceNameLabel.text = model.name
        serviceDescriptionLabel.text = model.description
        
        if let data = model.iconData {
            serviceImageView.image = UIImage(data: data)
        } else {
            downloadImage(url: model.icon_url) { [weak self] data in
                if let data = data {
                    model.iconData = data
                    self?.serviceImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

