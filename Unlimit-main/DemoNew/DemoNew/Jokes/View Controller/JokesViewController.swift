//
//  ViewController.swift
//  DemoNew
//

//

import UIKit

protocol JokesProtocol: AnyObject {
    func notify()
}

class JokesViewController: UIViewController, JokesProtocol {
    
    private let jokesTableView = UITableView()

    private var viewModel: JokesViewModel?
    
    weak var delegate: JokesProtocol?
 
    override func viewDidLoad() {
        let vModel = JokesViewModel(networkManager: NetworkManager(), jokesVc: self)
        vModel.getJokes()
        self.viewModel = vModel
        jokesTableView.rowHeight = UITableView.automaticDimension // Enable dynamic cell height
        view.addSubview(jokesTableView)
        setUpConstraints()
        registerCell()
    }
    
    private func registerCell() {
        jokesTableView.dataSource = self
        jokesTableView.delegate = self
        jokesTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    // setting constraints of Table View
    private func setUpConstraints() {
        jokesTableView.translatesAutoresizingMaskIntoConstraints = false
        jokesTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        jokesTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        jokesTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        jokesTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // protocol method to get notified every minute
    func notify() {
        DispatchQueue.main.async {
            self.jokesTableView.reloadData()
        }
    }
    
    func makeDifferenceInColor(indexPath: IndexPath, cell: CustomTableViewCell) {
        cell.backgroundColor = ((viewModel?.jokeCount ?? 0) - 1 == indexPath.row) ? .white : .opaqueSeparator
    }
    
}

// Extention for datasource methods
extension JokesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.jokeCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as? CustomTableViewCell {
            makeDifferenceInColor(indexPath: indexPath, cell: cell)
            cell.data = viewModel?.getJoke(at: indexPath.row)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

