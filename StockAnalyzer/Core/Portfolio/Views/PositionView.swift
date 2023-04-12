import SwiftUI

struct PositionView: View {
    @Environment(\.dismiss) private var dismiss
    let asset: Asset
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                VStack(alignment: .leading) {
                    Text("AAPL")
                        .fontWeight(.semibold)
                    Text("Apple Inc.")
                }
                Spacer()
                VStack {
                    Text("205.30")
                    Text("-0.59(-0.14%)")
                }
            }
            Divider()
            HStack(spacing: 20) {
                Text("Units")
                Spacer()
                Text("Invested")
                Spacer()
                Text("P / L")
                Spacer()
                Text("Value")
            }
            .padding(.horizontal)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "arrowshape.backward")
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        Text(asset.symbol)
    }
}

 struct PositionView_Previews: PreviewProvider {
     static let position1 = Position(symbol: "AAPL", date: "2020-02-02", units: 2.0, price: 132.5, investedAmount: 265.0)
     static let position2 = Position(symbol: "MSFT", date: "2020-02-02", units: 3.0, price: 230.0, investedAmount: 690.0)
     static let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positions: [position1, position2])
     
     static var previews: some View {
         PositionView(asset: asset)
     }
 }
 
