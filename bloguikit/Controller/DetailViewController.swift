//
//  DetailViewController.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/18/21.
//

import UIKit

class DetailViewController: UIViewController{
    
    
    
    lazy var contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var scrollView: UIScrollView = {
       let scroll = UIScrollView()
       scroll.contentSize = contentSize
       scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemBackground
        scroll.autoresizingMask = .flexibleHeight
        scroll.bounces = true
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
   
    
    lazy var titlePost: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    lazy var descriptionPost: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var datePost: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)

        return label
    }()
    
    
    lazy var imageView: ImageLoader = {

        let iv = ImageLoader()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
       //iv.clipsToBounds = true
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        
        view.addSubview(scrollView)
       
        
        scrollView.addSubview(stackView)
        
        stackView.addSubview(imageView)
        stackView.addSubview(descriptionPost)
        stackView.addSubview(titlePost)
        stackView.addSubview(datePost)
       
        
    }
    
    

    
    public func configure(model: Post){
        titlePost.text = model.title
        descriptionPost.text = model.description
        datePost.text = Utils.convertDateFormat(inputDate: model.date)
        imageView.loadImageWithUrl(URL(string: model.image)!)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

        
        NSLayoutConstraint.activate([
            
            

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -144),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titlePost.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titlePost.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            titlePost.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.98),
            
            datePost.topAnchor.constraint(equalTo: titlePost.bottomAnchor, constant: 10),
            datePost.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            datePost.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.98),

            descriptionPost.topAnchor.constraint(equalTo: datePost.bottomAnchor, constant: 20),
            descriptionPost.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            descriptionPost.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.98),
            
        ])
        
        DispatchQueue.main.async {
            self.sizee()
        }

    }
    
    func sizee(){
        
        var height: CGFloat = 0.0
        for v in stackView.subviews{
            height += v.frame.height
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)

    }
    
    

    


}



