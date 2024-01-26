import UIKit
import Firebase

class HomeController: UIViewController,HomeViewDelegate {
    private var homeView: HomeView!
    
    //MARK: - Variables
    let imagePickerManager = ImagePickerManager()
    let googleVisionAPI = GoogleVisionAPI()
    let apiKey = "AIzaSyB8RPFnB-3REc3sPTrkgbieQ5wkXT3OMck"
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid

   //MARK: - Functions
   public func pickImage() {
        imagePickerManager.pickImage(self) { [weak self] image in
            self?.googleVisionAPI.callGoogleVisionApi(image: image, apiKey: self!.apiKey) { detectedText in
                DispatchQueue.main.async {
                    print(detectedText ?? "Metin algılanamadı")
                    print("DEBUG PRINT:",detectedText as Any)
                }
            }
        }
    }
    public func didTapCameraButton() {
        imagePickerManager.pickImage(self) { image in
            let userId = self.userID!
            let userDocumentRef = self.db.collection("users").document(userId)
            self.homeView.imageView.image = image

            self.processImageAndIncrementPoints(image: image, apiKey: self.apiKey, firestoreDocumentRef: userDocumentRef)
            
            self.googleVisionAPI.documentToText(image: image, apiKey: self.apiKey) { ex in
                if let text = ex {
                    print("DEBUG PRINT:", text)
                } else {
                    print("DEBUG PRINT:HATA")
                }
            }
        }
    }
    
    func processImageAndIncrementPoints(image: UIImage, apiKey: String, firestoreDocumentRef: DocumentReference) {
        let targetBrands = ["ELIDOR", "PANTENE", "GILLETTE", "NAPOLITEN"]

        googleVisionAPI.callGoogleVisionApi(image: image, apiKey: apiKey) { detectedText in
            if let text = detectedText {
                var totalPointsToAdd = 0
                var detectedBrandsWithCounts = [(String, Int)]()
                
                for brand in targetBrands {
                    let count = text.numberOfOccurrences(of: brand)
                    if count > 0 {
                        detectedBrandsWithCounts.append((brand, count))
                        totalPointsToAdd += count * 10
                        print("\(brand): \(count) adet tespit edildi. +\(count * 10) puan.")
                    }
                }
                
                if totalPointsToAdd > 0 {
                    firestoreDocumentRef.getDocument { document, error in
                        if let document = document, document.exists {
                            var userPoint = document.data()?["userPoint"] as? Int ?? 0
                            userPoint += totalPointsToAdd
                            firestoreDocumentRef.updateData(["userPoint": userPoint]) { error in
                                if let error = error {
                                    print("Kullanıcı puanı güncellenirken hata oluştu: \(error)")
                                } else {
                                    print("Kullanıcı puanı başarıyla güncellendi")
                                    DispatchQueue.main.async {
                                        self.homeView.userPointLabel.text = "Points: \(userPoint)"
                                        let brandsText = detectedBrandsWithCounts.map { "\($0.0): \($0.1)" }.joined(separator: ", ")
                                        self.homeView.detectedTextLabel.text = "Tespit Edilen Marka: \(brandsText)"
                                    }
                                }
                            }
                        } else {
                            print("Belirtilen Firestore belgesi bulunamadı \(error?.localizedDescription ?? "Hata")")
                        }
                        
                    }
                    
                }
                else {
                    
                    self.showAlert(title: "Hata", message: "Anlasmali Marka Bulunamadi.")
                }
                
            }
        }
    }

    
    private func fetchUserPointsAndUpdateUI(){
        AuthService.shared.fetchCurrentUserPoint { [weak self] (userPoint, error) in
            DispatchQueue.main.async {
                if let userPoint = userPoint {
                    self?.homeView.userPointLabel.text = "Points: \(userPoint)"
                } else if let error = error {
                    print("Error fetching user points: \(error)")
                    self?.homeView.userPointLabel.text = "Points: Error"
                }
            }
        }
    }
   
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            print("Showing alert with title: \(title)") // Debug mesajı
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        homeView = HomeView()
        homeView.delegate = self
        view = homeView
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
            fetchUserPointsAndUpdateUI()
            
        }
        
                // MARK: - Selectors
                @objc private func didTapLogout() {
                    AuthService.shared.signOut { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            AlertManager.showLogoutError(on: self, with: error)
                            return
                        }
                        
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    }
                }
    }

    
      //MARK: - Extensions
// Extension to count occurrences of a substring in a string
extension String {
    func numberOfOccurrences(of substring: String) -> Int {
        return self.components(separatedBy: substring).count - 1
    }
}
      
    

    
   

