//
//  PostTableViewCell.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/17/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
    lazy var cardView: UIView = {
       let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 10
        card.layer.masksToBounds = true
        card.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        return card
    }()
    
    private var labelTitle: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var labelDate: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var image: ImageLoader = {

        let iv = ImageLoader()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
       //iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.masksToBounds = true
     
        
        contentView.addSubview(cardView)
        
        cardView.addSubview(labelTitle)
        cardView.addSubview(labelDate)
        cardView.addSubview(image)
        

     
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            cardView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),

            image.topAnchor.constraint(equalTo: cardView.topAnchor),
            image.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            image.heightAnchor.constraint(equalToConstant: 300),
            
            labelTitle.topAnchor.constraint(equalTo: image.bottomAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            labelTitle.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.5),
            labelTitle.heightAnchor.constraint(equalToConstant: 50),
            
            labelDate.topAnchor.constraint(equalTo: image.bottomAnchor),
            labelDate.leadingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -110),
            labelDate.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.5),
            labelDate.heightAnchor.constraint(equalToConstant: 50),
            

            
            
            
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelTitle.text = nil
        labelDate.text = nil
        image.image = nil
    
    }
    
    public func configure(model: Post){
        labelTitle.text = model.title
        labelDate.text = Utils.convertDateFormat(inputDate: model.date)
        image.loadImageWithUrl(URL(string: model.image)!)
     
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
