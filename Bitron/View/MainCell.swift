//
//  MainCell.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    let screen = UIScreen.main.bounds
    
    lazy var cryptoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cryptoSubValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var upArrowImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrow-up")?.withRenderingMode(.alwaysTemplate))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupColors()
        createSubViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame.origin.y = 30
        detailTextLabel?.frame.origin.y = 54
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupColors() {
        
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .gray
        backgroundColor = .clear
    }
    
    func createSubViews() {
        
        [cryptoValueLabel, upArrowImage, cryptoSubValueLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            cryptoValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            cryptoValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            upArrowImage.topAnchor.constraint(equalTo: topAnchor, constant: 57),
            upArrowImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 312),
            upArrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52),
            upArrowImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
            cryptoSubValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 54),
            cryptoSubValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
