
import UIKit

class PostTableViewController: UITableViewController {

    let cellID = "PostCell"
    var selectedThreadId: Int?
    var posts: [Post] = []
    
    var postsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let threadId = selectedThreadId else { return }
        let url = URL(string: "http://localhost:5000/getPosts?threadId=\(threadId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil
                else {
                    print("error", error ?? "Unknown error")
                    DispatchQueue.main.async {
                        self.present(AlertSupport.getPostsError(with: nil), animated: true)
                    }
                    return
                }

            if let postsArray = try? JSONDecoder().decode([Post].self, from: data) {
                self.posts = postsArray
                self.postsLoaded = true
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
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PostTableViewCell
        
        if postsLoaded {
            cell.username.text = "\(posts[indexPath.row].userId)"
            cell.content.text = posts[indexPath.row].content
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
