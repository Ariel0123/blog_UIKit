//
//  CreateViewController.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/17/21.
//

import UIKit

class CreateViewController: UIViewController {
    
    var name: String = ""
    var format: String = ""
    
    var post: Post?
    
    lazy var contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var viewModel: APIService = {
        let viewModel = APIService()
        return viewModel
    }()
    
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
    
    lazy var viewContainer: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var fieldTitle: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Title..."
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    lazy var textView: UITextView = {
       let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.isSelectable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentSize = CGSize(width: view.frame.width, height: 350)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.text = "Text..."
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
  
    
    lazy var imageView: ImageLoader = {

        let imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private var buttonCreate: UIButton = {
       let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        return button
    }()
    
    private var openImage: UIButton = {
       let button = UIButton()
        button.setTitle("Pick Image", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Post"
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(viewContainer)

        
        viewContainer.addSubview(fieldTitle)
        viewContainer.addSubview(textView)
        viewContainer.addSubview(imageView)
        viewContainer.addSubview(openImage)
        viewContainer.addSubview(buttonCreate)
        
        textView.delegate = self
        
        viewModel.errorMessage.bind { [weak self] _ in
            DispatchQueue.main.async {
                if let err = self?.viewModel.errorMessage.value{
                    self?.showAlert(message: err)
                }
               
               // self?.showAlert(message: )
           
           }
          }
        
        
        if post != nil{
            fillFields()
        }
    }
    
    
    @objc private func pickImage(){
        updateLayout()
        showImagePickerControllerActionSheet()
    }
    
    @objc private func createPost() throws {
        do{
            try checkFields()
        }catch PostErrors.title{
            showAlert(message: PostErrors.title.msgError)
        }
    }
    
    private func fillFields(){
        title = "Update Post"
        fieldTitle.text = post?.title
        textView.text = post?.description
        textView.textColor = UIColor.black
        imageView.loadImageWithUrl(URL(string: post!.image)!)
        buttonCreate.setTitle("Update", for: .normal)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        if (post != nil){
            NSLayoutConstraint.activate([
                
                
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                viewContainer.topAnchor.constraint(equalTo: view.topAnchor),
                viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                viewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                fieldTitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
                fieldTitle.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                fieldTitle.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
                fieldTitle.heightAnchor.constraint(equalToConstant: 40),
                
                textView.topAnchor.constraint(equalTo: fieldTitle.bottomAnchor, constant: 20),
                textView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                textView.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
                textView.heightAnchor.constraint(equalToConstant: 350),
                
                imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
                imageView.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 300),
                imageView.centerXAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.centerXAnchor),

                openImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                openImage.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                openImage.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                
                buttonCreate.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                buttonCreate.trailingAnchor.constraint(equalTo:  scrollView.layoutMarginsGuide.trailingAnchor),
                buttonCreate.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
       
                
                
            ])
            
        }else{
        
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            fieldTitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            fieldTitle.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            fieldTitle.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
            fieldTitle.heightAnchor.constraint(equalToConstant: 40),
            
            textView.topAnchor.constraint(equalTo: fieldTitle.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            textView.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
            textView.heightAnchor.constraint(equalToConstant: 350),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.centerXAnchor),

            openImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            openImage.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            openImage.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            
            buttonCreate.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            buttonCreate.trailingAnchor.constraint(equalTo:  scrollView.layoutMarginsGuide.trailingAnchor),
            buttonCreate.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            
            
   
            
            
        ])
        }
        DispatchQueue.main.async {
            self.sizee()
        }

       
    }
    
    
    private func updateLayout(){
        NSLayoutConstraint.activate([
            
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fieldTitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            fieldTitle.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            fieldTitle.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
            fieldTitle.heightAnchor.constraint(equalToConstant: 40),
            
            textView.topAnchor.constraint(equalTo: fieldTitle.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            textView.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
            textView.heightAnchor.constraint(equalToConstant: 350),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.centerXAnchor),

            openImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            openImage.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            openImage.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            
            buttonCreate.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            buttonCreate.trailingAnchor.constraint(equalTo:  scrollView.layoutMarginsGuide.trailingAnchor),
            buttonCreate.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
   
            
            
        ])
        
        DispatchQueue.main.async {
            self.sizee()
        }

    }
    
  
    
    private func sizee(){
        
        var height: CGFloat = 0.0
        for v in viewContainer.subviews{
            height += v.frame.height
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height+100)

    }
    
    
    private func checkFields() throws {
      
            
            let title = fieldTitle.text
            let description = textView.text
            let img = imageView.image
            
            if ((post?.id) != nil){
                
                
               
                
                viewModel.runUpdatePost(id: post!.id.description, title: title!, description: description!, image: img!, name: name, format: format){ result in
                        if result{
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                
                
                
            }else{
            
                
                viewModel.runCreatePost(title: title!, description: description!, image: img!, name: name, format: format){result in
                    if result{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
        
                
            }
        
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))


        self.present(alert, animated: true)
    }
    

   

}



extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private func showImagePickerControllerActionSheet(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Choose from library", style: .default){action in
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "Take from Camera", style: .default){action in
            self.showImagePickerController(sourceType: .camera)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    private func showImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageView.image = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = originalImage
        }
        
        if let pathName = info[.imageURL] as? URL {
            self.name = pathName.deletingPathExtension().lastPathComponent
        }
        
        if let pathFormat = info[.imageURL] as? URL {
            self.format = pathFormat.pathExtension
        }
        
        dismiss(animated: true, completion: nil)
    }
}




extension CreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
