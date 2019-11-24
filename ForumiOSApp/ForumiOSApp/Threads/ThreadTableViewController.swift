
import UIKit

class ThreadTableViewController: UITableViewController {
        
    private let cellID = "ThreadTableCell"
    private var threads: [Thread] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Threads"
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        // get threads from db
        let service = ServerNetwork()
        guard let threadsData = service.getThreads() else { return }
        
        do {
            threads = try JSONDecoder().decode([Thread].self, from: threadsData)
            print(threads)
        } catch let error{
            print(error)
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ThreadTableViewCell
        
        
        cell.threadTitle.text = "Mobile Development"
        cell.threadDescription.text = "This thread about Ilya. He is lox"
        cell.postCountLabel.text = "24123"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(PostTableViewController(), animated: true)
    }
}

