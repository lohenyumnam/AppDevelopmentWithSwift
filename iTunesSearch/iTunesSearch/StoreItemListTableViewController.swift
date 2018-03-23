
import UIKit

class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    var storeItemController = StoreItemController()

    var items = [StoreItem]()
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            print("\(searchTerm) \(mediaType)")
            // set up query dictionary
            let query: [String: String] = [
                "term": "\(searchTerm.lowercased())",
                "lang": "en_us",
                "media": "\(mediaType)"
            ]
            
            // use the item controller to fetch items
            storeItemController.fetchItems(matching: query, completion: { (storeItem) in
                if let storeItem = storeItem {
                    // if successful, use the main queue to set self.items and reload the table view
                    self.items = storeItem
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    // otherwise, print an error to the console
                    print("There was error in fetching the item")
                }
            })
         }
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name // set label to the item's name
        cell.detailTextLabel?.text = item.description // set detail label to the item's subtitle
        cell.imageView?.image = #imageLiteral(resourceName: "gray") // reset the image view to the gray image

        // initialize a network task to fetch the item's artwork
        let task = URLSession.shared.dataTask(with: item.artworkURL) { (data, response, error) in
            if let data = data, let img = UIImage(data: data){
                // if successful, use the main queue capture the cell, to initialize a UIImage, and set the cell's image view's image to the
                DispatchQueue.main.async {
                    cell.imageView?.image = img
                }
            }
        }
        // resume the task
        task.resume()
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
