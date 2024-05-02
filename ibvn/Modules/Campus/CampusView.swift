//
//  CampusView.swift
//  ibvn
//
//  Created by Jose Letona on 1/5/24.
//

import SwiftUI

struct CampusView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: CampusViewModel
    
    // MARK: Initialization
    init(viewModel: CampusViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        campusContent(viewModel.campus.first ?? .init())
    }
    
    func campusContent(_ campus: Campus) -> some View {
        VStack {
            Text(campus.name)
            Text(campus.address)
            Text(campus.country)
            Text(campus.pastor)
            AsyncImage(url: URL(string: campus.pastorImage)) { image in
                image.resizable().centerCropped()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 66)
            .clipped()
            .cornerRadius(8)
            Text(campus.phone)
            Text(campus.whatsapp)
        }
    }
}

#Preview {
    CampusView(viewModel: CampusViewModel())
}
