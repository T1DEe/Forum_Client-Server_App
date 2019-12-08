
import UIKit

class ThreadTableViewController: UITableViewController {
        
    private let cellID = "ThreadCell"
    private var threads: [Thread] = []
    private var threadsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Threads"
        
        
        let url = URL(string: "http://localhost:5000/getThreads")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil
                else {
                    print("error", error ?? "Unknown error")
                    DispatchQueue.main.async {
                        self.present(AlertSupport.getThreadsError(with: nil), animated: true)
                    }
                    return
                }

            if let threadsArray = try? JSONDecoder().decode([Thread].self, from: data) {
                self.threads = threadsArray
                self.threadsLoaded = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.present(AlertSupport.authError(with: nil), animated: true)
                }
            }
        }
        task.resume()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: "#0096FF")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ThreadTableViewCell
        if threadsLoaded {
            cell.threadTitle.text = threads[indexPath.row].title
            cell.threadDescription.text = threads[indexPath.row].description
            cell.postCountLabel.text = String(describing: threads[indexPath.row].post_count)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postsVC = PostTableViewController()
        postsVC.selectedThreadId = threads[indexPath.row].id
        postsVC.title = threads[indexPath.row].title
        
        navigationController?.pushViewController(postsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

