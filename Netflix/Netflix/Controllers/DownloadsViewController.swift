//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Mohamed Ismail on 01/09/2023.


import UIKit

class DownloadsViewController: UIViewController {
    
    private var downloads: [TitleItem] = [TitleItem]()
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(DownloadsTableViewCell.self, forCellReuseIdentifier: "DownloadsTableViewCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Downloads"
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDownloads()
    }
    
    private func fetchDownloads() {
          CoreData.shared.fetchDownloads { result in
              switch result {
              case.success(let titles):
                  self.downloads = titles
                  self.tableView.reloadData()
              case.failure(let error):
                  print(error)
              }
          }
      }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return downloads.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "DownloadsTableViewCell", for: indexPath) as? DownloadsTableViewCell else {
            return UITableViewCell() }
        
        guard let currentTitle = downloads[indexPath.section].original_title else { return UITableViewCell() }
        guard let currentOverview = downloads[indexPath.section].overview else { return UITableViewCell() }
        guard let currentPosterPath = downloads[indexPath.section].poster_path else { return UITableViewCell() }
        tableCell.passToDownloadsViewCell(currentTitle: currentTitle, currentOverview: currentOverview, currentPosterPath: currentPosterPath)
        tableCell.delegate = self
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return downloads[section].original_title
    }
    
}

extension DownloadsViewController: DownloadsViewTableViewCellDelegate {
    func downloadsViewTableViewCellDidTapCell(_ cell: DownloadsTableViewCell, viewModel: Preview) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.passToPreviewView(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
