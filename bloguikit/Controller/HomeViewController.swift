//
//  HomeViewController.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/16/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    
  

    lazy var viewModel: APIService = {
        let viewModel = APIService()
        return viewModel
    }()

    
    private var tableView: UITableView = {
       let table = UITableView()
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createPost))
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        viewModel.posts.bind { [weak self] _ in
            DispatchQueue.main.async {
           
            self?.tableView.reloadData()
            }
          }
        
        
        viewModel.errorMessage.bind { [weak self] _ in
            DispatchQueue.main.async {
                if let err = self?.viewModel.errorMessage.value{
                    self?.showAlert(message: err)
                }
                          
           }
          }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        viewModel.runGetPosts()
        
      
        

       
        
       
       
    }
  
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    
    @objc private func createPost(){
        let vc = CreateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func goUpdate(post: Post){
        let vc = CreateViewController()
        vc.post = post
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func deletePost(id: String){
        
        viewModel.runDeletePost(id: id)
        
    }
    


}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        cell.configure(model: viewModel.posts.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let update = UIAction(title: "Edit", image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off){ _ in
            self.goUpdate(post: self.viewModel.posts.value[indexPath.row])
        }

        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){ _ in
            self.deletePost(id: self.viewModel.posts.value[indexPath.row].id.description)
        }

        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ _ in
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [update, delete])
        }

        return config

    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.configure(model: viewModel.posts.value[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    
}
