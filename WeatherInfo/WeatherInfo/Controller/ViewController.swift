//
//  ViewController.swift
//  WeatherInfo
//
//  Created by 김동규 on 2022/01/14.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    let cellIdentifier: String = "Country Cell"
    var countries: [Country] = []
    var assetName: String?
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Protocol Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let country: Country = self.countries[indexPath.row]

        cell.textLabel?.text = country.name
        cell.imageView?.image = UIImage(named: country.imageName)
        
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: SecondViewController = segue.destination as? SecondViewController else {
            return
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let country: Country = self.countries[indexPath.row]
            nextViewController.countryName = country.name
            nextViewController.assetName = country.assetName
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "세계 날씨"
        if let navBar = self.navigationController?.navigationBar {
            navBar.tintColor = .white
            navBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
            ]
        }
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "countries") else {
            return
        }
        
        do {
            self.countries = try jsonDecoder.decode([Country].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
}

