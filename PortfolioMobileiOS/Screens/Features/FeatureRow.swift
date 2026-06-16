import SwiftUI

struct FeatureRow: View {
    
    let feature: Feature
    
    var body: some View {
        HStack(spacing: .zero) {
            Text(feature.title)
                .headlineFont()
                .foregroundStyle(.textPrimary)
            Spacer()
            SymbolImage.arrowRight
                .headlineFont()
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.primaryWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .paleGray, radius: 8, x: .zero, y: 8)
    }
}

#Preview {
    let feature: Feature = .init(
        id: "feature_location",
        title: "Location",
        category: .location
    )
    FeatureRow(feature: feature)
}

