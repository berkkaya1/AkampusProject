import Foundation
import UIKit

class GoogleVisionAPI {
    
    public func documentToText(image: UIImage, apiKey: String, completion: @escaping (String?) -> Void) {
       callGoogleVisionApi(image: image, apiKey: apiKey) { detectedText in
         completion(detectedText)
       }
     }
    
   public func callGoogleVisionApi(image: UIImage, apiKey: String, completion: @escaping (String?) -> Void) {
        guard let base64Image = image.jpegData(compressionQuality: 0.9)?.base64EncodedString() else {
            print("Resim base64'e dönüştürülemedi.")
            completion(nil)
            return
        }
        let apiUrl = "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyB8RPFnB-3REc3sPTrkgbieQ5wkXT3OMck"
        guard let url = URL(string: apiUrl) else { return }

        let requestBody: [String: Any] = [
            "requests": [
                [
                    "image": ["content": base64Image],
                    "features": [["type": "TEXT_DETECTION"]]
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("JSON verisi oluşturulurken hata oluştu.")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Hata: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(nil)
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let responses = jsonResponse["responses"] as? [[String: Any]],
                   let fullTextAnnotation = responses.first?["fullTextAnnotation"] as? [String: Any],
                   let detectedText = fullTextAnnotation["text"] as? String {
                    completion(detectedText)
                } else {
                    print("Yanıt işlenemedi.")
                    completion(nil)
                }
            } catch {
                print("Yanıt JSON olarak ayrıştırılamadı.")
                completion(nil)
            }
        }.resume()
       
       
    }
    
}
