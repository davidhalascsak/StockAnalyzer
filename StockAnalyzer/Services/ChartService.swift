import Foundation
import Combine

class ChartService {
    @Published var historicData: [Price] = []
    
    var dataSubscription: AnyCancellable?
    
    func getDaily() {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/15min/AAPL?apikey=d5f365f0f57c273c26a6b52b86a53010")
        else {return}
                
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: [Price].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.historicData = returnedData
                
                self?.createDailyData()
            
                
                self?.dataSubscription?.cancel()
            })
    }
    // func getWeekly
    // func getMonthly
    // ...
    
    func createDailyData() {
        
        var daily = [Price]()
        for i in 0..<self.historicData.count {
            if self.historicData[i].date[0..<11] == self.historicData[0].date[0..<11] {
                daily.append(self.historicData[i])
            } else {
                break
            }
        }
        print(daily)
    }
}

struct Price: Codable {
    let date: String
    let open: Double
    let close: Double
}




extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
