//
//  TitlePreviewViewController.swift
//  Netflix
//
//  Created by Mohamed Ismail on 03/09/2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private var currentModel: Title = Title(original_name: "", original_title: "", overview: "", poster_path: "")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0 // Set to 0 to allow multiple lines if needed
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        downloadButton.isUserInteractionEnabled = true
        downloadButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        let buttonTitle = downloadButton.title(for: .normal)
        if buttonTitle == "Download" {
            CoreData.shared.downloadTitle(model: currentModel) { result in
                switch result {
                case.success(let result):
                    print("Downloaded")
                    print(result)
                case.failure(let error):
                    print(error)
                }
            }
        }
        
        if buttonTitle == "Remove" {
            CoreData.shared.removeTitle(model: currentModel) { result in
                switch result {
                case.success(let result):
                    print("Removed")
                    print(result)
                case.failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private func checkDownloaded() {
        CoreData.shared.fetchDownloads { result in
            switch result {
            case.success(let downloads):
                for title in downloads {
                    if title.original_title == self.currentModel.original_title {
                        self.downloadButton.setTitle("Remove", for: .normal)
                    }
                }
            case.failure(let error):
                print(error)
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        configureConstraints()
        setupTapGesture()
        checkDownloaded()
    }
    
    func configureConstraints() {
        
        let webViewConstraint = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraint)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    public func passToPreviewView(with model: Preview) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        currentModel = Title(original_name: "", original_title: model.title, overview: model.titleOverview, poster_path: model.posterPath)
        webView.load(URLRequest(url: url))
    }
    
    



}
