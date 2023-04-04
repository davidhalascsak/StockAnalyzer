
import SwiftUI

struct PortfolioRowView: View {
    let asset: Asset
    
    var body: some View {
        VStack {
            HStack {
                Text(asset.symbol)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", asset.units))
                Spacer()
                Text(String(format: "%.2f", asset.averagePrice))
                Spacer()
                Text(String(format: "%.2f", asset.currentValue))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            Divider()
        }
    }
}

struct PortfolioRowView_Previews: PreviewProvider {
    static let asset = Asset(symbol: "Apple", units: 1.00, averagePrice: 132.00, currentValue: 160.00)
    static var previews: some View {
        PortfolioRowView(asset: asset)
    }
}
