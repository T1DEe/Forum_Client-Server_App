
import Foundation

class ServerNetwork: NSObject {
    
    let hostname = "http://localhost"
    let port = 5000
    
    private let getThreadsPath = "/getThreads"
    private let getPostsPath = "/getPosts"
    private let authUserPath = "/authUser"
    
    private var dataTask: URLSessionDataTask?
    private var urlRequest: URLRequest?
    private var data = Data()
    
    
    func getThreads() -> Data? {
        guard let url = URL(string: hostname + ":\(port)" + getThreadsPath) else { return nil }
        urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        guard let urlReq = urlRequest else {
            return nil
        }
        dataTask = session.dataTask(with: urlReq)
        dataTask?.resume()
        
        
        return self.data
    }
}


extension ServerNetwork: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // mb need to use switch statment
        if dataTask.currentRequest == urlRequest {
            self.data.append(data)
        }
    }
    

}
