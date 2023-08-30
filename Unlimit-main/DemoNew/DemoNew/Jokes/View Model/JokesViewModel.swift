//
//  JokesViewModel.swift
//  DemoNew
//

//
protocol Appendable {
    associatedtype Item
    func append(_ element: Item)
}

import Foundation

class JokesViewModel: Appendable {
    
    typealias Item = Jokes
    
    private var jokes: [Jokes] = []
    
    private let networkManager: NetworkManager?
    
    private var timer: Timer?
    
    weak var delegate: JokesProtocol?
    
    private let savedJokesKey = "SavedJokes"
    
    init(networkManager: NetworkManager,
         jokesVc: JokesViewController) {
        
        self.networkManager = networkManager
        self.delegate = jokesVc
        
        timer =  Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        loadSavedJokes()
    }
    
    var jokeCount: Int {
        return jokes.count
    }
    
    private func loadSavedJokes() {
        guard let jokesData = UserDefaults.standard.data(forKey: savedJokesKey) else {
            return
        }
        jokes = (try? JSONDecoder().decode([Jokes].self, from: jokesData)) ?? []
    }
    
     func saveJokes() {
        let jokesData = try? JSONEncoder().encode(jokes)
        UserDefaults.standard.set(jokesData, forKey: savedJokesKey)
    }
    
     func addJoke(_ joke: Jokes) {
        self.append(joke)
        if jokes.count > 10 {
            jokes.removeFirst()
        }
        delegate?.notify()
    }
    
    @objc func runTimedCode() {
        getJokes()
    }
    
    func getJokes() {
        networkManager?.getRequest(url: Constants.jokesUrl, completion: { joke in
            self.addJoke(joke)
            self.saveJokes()
        })
    }
    
    func getJoke(at index: Int) -> String {
        return jokes[index].joke
    }
    
    // protocol method
    func append(_ element: Jokes) {
        jokes.append(element)
    }
    
    deinit {
        timer?.invalidate()
    }
}
