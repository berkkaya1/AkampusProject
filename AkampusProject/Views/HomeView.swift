//
//  HomeView.swift
//  AkampusProject
//
//  Created by Berk Kaya on 20.01.2024.
//

import UIKit
class HomeView: UIView {
    weak var delegate: HomeViewDelegate?

    // MARK: - UI Components
    let imageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFit
           iv.clipsToBounds = true
           iv.layer.borderColor = UIColor.black.cgColor
           iv.layer.borderWidth = 1.0
           return iv
       }()
    
    let iconImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFit
          imageView.image = UIImage(systemName: "star.fill")
          return imageView
      }()
    
    let userPointLabel: UILabel = {
            let label = UILabel()
            label.textColor = .label
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.text = "Points: ?"
            return label
        }()
    
    let detectedTextLabel: UILabel = {
          let label = UILabel()
        label.text = "Loding..."
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.cornerRadius = 30

        
        return label
      }()
    
  
    
    let cameraButton: UIBarButtonItem = {
           let button = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
           return button
       }()

       let toolbar: UIToolbar = {
           let toolbar = UIToolbar()
           toolbar.translatesAutoresizingMaskIntoConstraints = false
           return toolbar
       }()

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // Set the toolbar items with the flexible spaces and the camera button
        toolbar.setItems([flexibleSpace, cameraButton, flexibleSpace], animated: false)
        addSubview(toolbar)

               NSLayoutConstraint.activate([
                   // ... existing constraints ...
                toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                       toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                       toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
               ])
        
        
               cameraButton.target = self
               cameraButton.action = #selector(cameraButtonTapped)
        
        
       
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            iconImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

       
        addSubview(userPointLabel)
        userPointLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userPointLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            userPointLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
        
        addSubview(detectedTextLabel)
        detectedTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detectedTextLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            detectedTextLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            detectedTextLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            detectedTextLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: detectedTextLabel.bottomAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    @objc private func cameraButtonTapped() {
           delegate?.didTapCameraButton()
       }
}

// MARK: - Protocols
protocol HomeViewDelegate: AnyObject {
    func didTapCameraButton()
}
