import Foundation

open class Remark {
    let appIdentifier: String

    init(appIdentifier: String) {
        self.appIdentifier = appIdentifier
    }

    let dispatchGroup = DispatchGroup()

    func reviewsFeedURL(appId: String, country: Country) -> URL? {
        return URL(string: "https://itunes.apple.com/\(country.rawValue)/rss/customerreviews/id=\(appId)/sortBy=mostRecent/json")
    }

    func fetchReviews(country: Country, completion: @escaping (([Review]?) -> Void)) {
        let url = reviewsFeedURL(appId: appIdentifier, country: country)!

        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            if let response = try? decoder.decode(APIResponse.self, from: data) {
                let reviews = response.feed.entries.map { Review(entry: $0) }
                completion(reviews)
                return
            }
            completion([])
        }
        session.resume()
    }

    func fetchReviews(countries: [Country] = Country.allCases, completion: @escaping (([Remark.Country: [Review]]) -> Void)) {
        var reviewsPerCountry: [Remark.Country: [Review]] = [:]
        dispatchGroup.wait()
        for country in countries {
            dispatchGroup.enter()
            fetchReviews(country: country) { [weak self] reviews in
                reviewsPerCountry[country] = reviews
                self?.dispatchGroup.leave()
            }
        }

        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(reviewsPerCountry)
        }
    }
}
