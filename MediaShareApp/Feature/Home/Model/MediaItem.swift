import Foundation

struct MediaItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let type: String
    let downloadURL: String
    let isLiked: Bool
    
    private(set) var data: Data? 
    
    init(id: Int,name: String, type: String, downloadURL: String, isLiked: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.downloadURL = downloadURL
        self.isLiked = isLiked
    }
    
    init(from response: GetUserMediaResponse.Media) {
        self.id = response.id
        self.name = response.name
        self.type = response.type
        self.downloadURL = response.download_url
        self.isLiked = response.is_liked
    }
    
    mutating func loadData(_ completion: @escaping (MediaItem) -> Void) {
        guard let url = URL(string: downloadURL) else { return }
        
        var mutableSelf = self
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                mutableSelf.data = data
                completion(mutableSelf)
            }
        }.resume()
        
        self = mutableSelf
    }
}
