//  AuthService.swift
//  AkampusProject
//
//  Created by Berk Kaya on 19.01.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService{
    public static let shared = AuthService()
    
    private init(){
        
    }
    
    public func registerUser(with userRequest: RegisterUserRequest, completion:@escaping(Bool,Error?)->Void){
        let email = userRequest.email
        let password = userRequest.password
        let userPoint = userRequest.userPoint
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false,error)
                return
            }
            guard let resultUser = result?.user else{
                completion(false,nil)
                return
            }
            let db = Firestore.firestore()
            db.collection("users").document(resultUser.uid).setData([
                "email" : email,
                "password": password,
                "userPoint": userPoint
            ]) { error in
                if let error = error {
                    completion(false,error)
                    return
                }
                completion(true,nil)
            }
        }
    }
    
    
    public func signIn(with userRequest:LoginUserRequest,completion: @escaping (Error?)->Void){
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else{
                completion(nil)
            }
        }
    }
    
    
    public func signOut(completion: @escaping (Error?)->Void){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch let error {
            completion(error)
        }
    }
}

extension AuthService {
    public func fetchCurrentUserPoint(completion: @escaping (Int?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil, nil)
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currentUser.uid)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let document = document, document.exists {
                if let userPoint = document.data()?["userPoint"] as? Int {
                    completion(userPoint, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
}


