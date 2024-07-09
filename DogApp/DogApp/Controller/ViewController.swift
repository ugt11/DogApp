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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 戻った時に選択表示を解除
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let breed = dogBreeds[indexPath.row]
        cell.textLabel?.text = breed
        cell.textLabel?.textColor = .systemGray6
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
