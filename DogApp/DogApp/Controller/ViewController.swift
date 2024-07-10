//
//  ViewController.swift
//  DogApp
//
//  Created by spark-04 on 2024/06/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let dogData = DogData()
    var dogBreeds: [String] = []
    var selectedBreed: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        fetchDogBreeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 戻った時に選択表示を解除
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func configureNavigationBar() {
        // ナビゲーションバーのタイトルを設定
        self.title = "Dog Breeds"
        
        // ナビゲーションバーの色を設定
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray6]
            navigationBar.barTintColor = UIColor.black
            // ナビゲーションバーの透過性を無効にする
            navigationBar.isTranslucent = false
        }
    }
    
    private func fetchDogBreeds() {
        DogData.fetchDogBreeds { result in
            switch result {
            case .success(let dogBreedsResponse):
                self.dogBreeds = Array(dogBreedsResponse.message.keys).sorted()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let breed = dogBreeds[indexPath.row]
        cell.textLabel?.text = breed
        cell.textLabel?.textColor = .systemGray6 // 指定された色を使用
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectedBreed = dogBreeds[indexPath.row]
        print("選択された犬の名前: \(selectedBreed ?? "")")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            if let collectionViewController = segue.destination as? CollectionViewController {
                collectionViewController.breed = selectedBreed
            }
        }
    }
}
