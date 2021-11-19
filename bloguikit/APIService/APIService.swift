//
//  APIService.swift
//  bloguikit
//
//  Created by Ariel Ortiz on 10/17/21.
//

import Foundation
import UIKit

typealias Parameters = [String: String]


class APIService{
    
   // static let shared = APIService()
    

    
    
    let urlAPI = "http://127.0.0.1:8000/post/"
    
    var posts: Observable<[Post]> = Observable([]) //2
    var errorMessage: Observable<String?> = Observable(nil)
    
    
    public func runGetPosts(){
        
        do{
        
        try getPosts(){ result in
            switch result{
            case .success(let results):
                
                self.posts.value = results
            case .failure(let error):
                self.errorMessage.value = error.msgError
                
            }
        }
            
        }catch{
            print("error")
        }
    }
    
    private func getPosts(completion: @escaping (Result<[Post], PostErrorsCatch>) -> ()) throws {
        
        let url = URL(string: urlAPI)
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            
            DispatchQueue.main.async{
            if let error = error{
                completion(.failure(.catchError))
                
            }else if let data = data{
                
                
                
                do{
                    
                    let result = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(result))
                    
                }catch{
                    completion(.failure(.catchError))
                }
            }else{
                completion(.failure(.catchError))
            }
        }
            
            
            
            
        }.resume()
        
    }
    
    public func runCreatePost(title: String, description: String, image: UIImage, name: String, format: String, completion: @escaping (Bool)->()){
        do{
            try createPost(title: title, description: description, image: image, name: name, format: format){result in
                switch result{
                case .success(_):
                    completion(true)
                    
                case .failure(let error):
                    self.errorMessage.value = error.msgError
                    completion(false)
                }
            }
        }catch{
            print(error)
            
        }
        
    }
    
    
    private func createPost(title: String, description: String, image: UIImage, name: String, format: String, completion: @escaping (Result<Post, PostErrorsCatch>)->()) throws {
        
        
        let url = URL(string: urlAPI)

        
        guard let mediaImage = Media(withImage: image, forKey: "image", filename: name, mimeType: format) else { return }
        
        let body = ["title": title, "description": description]
        
        let boundary = generateBoundary()

        
        var request = URLRequest(url: url!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let dataBody = createDataBody(withParameters: body, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            DispatchQueue.main.async{

            if let err = err{
                completion(.failure(.catchError))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(Post.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    print(data.base64EncodedString())
                    let errorServer = try! JSONDecoder().decode(PostUniversalErrorsMessage.self, from: data)
                    self.errorMessage.value = errorServer.title![0]
                }
            }else{
                completion(.failure(.catchError))
            }
            }
            
        }.resume()
        
       
    }
    
    
    public func runUpdatePost(id: String ,title: String, description: String, image: UIImage, name: String, format: String, completion: @escaping (Bool) ->()){
        do{
            try updatePost(id: id, title: title, description: description, image: image, name: name, format: format){ result in
                switch result{
                case .success(_):
                    completion(true)
                case .failure(let error):
                    self.errorMessage.value = error.msgError
                    completion(false)
                }
            }
        
        }catch{
            print(error)
            
        }
        
    }
    
    
    
    private func updatePost(id: String, title: String, description: String, image: UIImage, name: String, format: String, completion: @escaping (Result<Post, PostErrorsCatch>)->()) throws {
        
        
        let deleteURL = "\(urlAPI)\(id)/"
        
        guard let url = URL(string: deleteURL) else{
            return
       
        }
        
        var request = URLRequest(url: url)
        
        let body = ["title": title, "description": description]
        
        if !name.isEmpty{
            
            
            guard let mediaImage = Media(withImage: image, forKey: "image", filename: name, mimeType: format) else { return }
            
            
            
            let boundary = generateBoundary()

            
           
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            
            let dataBody = createDataBody(withParameters: body, media: [mediaImage], boundary: boundary)
            request.httpBody = dataBody
            
        }else{
            
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = data
            
            print("ferfere")
            
        }

        
        
      
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            DispatchQueue.main.async{

            if let err = err{
                completion(.failure(.catchError))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(Post.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    print(data.base64EncodedString())
                    let errorServer = try! JSONDecoder().decode(PostUniversalErrorsMessage.self, from: data)
                    self.errorMessage.value = "Title: \(errorServer.title![0])"
                }
            }else{
                completion(.failure(.catchError))
            }
            }
            
        }.resume()
        
       
    }
    
    
    public func runDeletePost(id: String){
        do{
            try deletePost(id: id){ result in
                switch result{
                case .success(_):
                    self.runGetPosts()
                case .failure(let error):
                    self.errorMessage.value = error.msgError
                }
            }
        }catch{
            
            print(error)
        }
    }
    
    
 
    private func deletePost(id: String, completion: @escaping (Result<Bool,PostErrorsCatch>) -> ()) throws {
        
        let deleteURL = "\(urlAPI)\(id)/"
        
        guard let url = URL(string: deleteURL) else{
            return
       
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            
            DispatchQueue.main.async{
            if let error = error{
                completion(.failure(.catchError))
                
            }else if let data = data{
               
                    completion(.success(true))
                    
                
            }else{
                completion(.failure(.catchError))
            }
            
        }
            
            
            
            
        }.resume()
    }
    
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
            
            let lineBreak = "\r\n"
            var body = Data()
            
            if let parameters = params {
                for (key, value) in parameters {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                    body.append("\(value + lineBreak)")
                }
            }
            
            if let media = media {
                for photo in media {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                    body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                    body.append(photo.data)
                    body.append(lineBreak)
                }
            }
            
            body.append("--\(boundary)--\(lineBreak)")
            
            return body
        }
    
    
    func generateBoundary() -> String {
         return "Boundary-\(NSUUID().uuidString)"
     }
       
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
