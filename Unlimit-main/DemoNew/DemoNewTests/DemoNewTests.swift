//
//  DemoNewTests.swift
//  DemoNewTests
//
//  Created by B0249370 on 09/06/23.
//

import XCTest
@testable import DemoNew

final class DemoNewTests: XCTestCase {
    
    var viewModel: JokesViewModel!
    var mockNetworkManager: NetworkManager!
    var jokesVc = JokesViewController()
       override func setUp() {
           super.setUp()
           mockNetworkManager = NetworkManager()
           jokesVc = JokesViewController()
           viewModel = JokesViewModel(networkManager: mockNetworkManager, jokesVc: jokesVc)
           UserDefaults.standard.removeObject(forKey: "SavedJokes") // Clear saved jokes before each test
       }

       override func tearDown() {
           viewModel = nil
           super.tearDown()
       }

       func testJokeCount() {
           XCTAssertEqual(viewModel.jokeCount, 0, "Initial joke count should be 0")
           
           let joke = Jokes(joke: "Test joke")
           viewModel.addJoke(joke)
           XCTAssertEqual(viewModel.jokeCount, 1, "Joke count should increase after adding a joke")
       }
       
       func testGetJoke() {
           let joke = Jokes(joke: "Test joke")
           viewModel.addJoke(joke)
           
           let retrievedJoke = viewModel.getJoke(at: 0)
           XCTAssertNotNil(retrievedJoke)
       }
    
        func testAddJoke() {
            let joke = Jokes(joke: "Test joke")
            viewModel.append(joke)
                      
            let retrievedJoke = viewModel.getJoke(at: 0)
            XCTAssertNotNil(retrievedJoke)
        }


}
