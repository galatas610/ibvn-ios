//
//  CampusView.swift
//  ibvn
//
//  Created by Jose Letona on 1/5/24.
//

import SwiftUI
import UIKit
import MapKit

struct CampusView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: CampusViewModel
    @State private var campus: Campus = .init()
   
    // MARK: Variables
       let pasteboard = UIPasteboard.general
    
    // MARK: Initialization
    init(viewModel: CampusViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            VStack {
                logo
                
                HStack(spacing: 32) {
                    ForEach(viewModel.pastor ?? [], id: \.id) { pastor in
                        generalPastor(with: pastor)
                    }
                }
                
                Divider()
            }
            .background(Constants.primaryDark)
           
            HStack {
                leftArrow
                
                Spacer()
                
                campusContent(campus)
                
                Spacer()
                
                rightArrow
                
            }
            
            CampusMapView(campus: campus, locations: viewModel.campusLocations)
            
        }
        .onChange(of: viewModel.campus ?? .init()) { campus in
            self.campus = campus.first ?? .init()
        }
    }
    
    private var logo: some View {
        Image("IbvnLogo")
            .resizable()
            .frame(width: 120, height: 31)
            .padding(.vertical, 16)
    }
    
    private var leftArrow: some View {
        Button {
            self.campus = viewModel.moveToPreviousCampus(currentCampus: self.campus)
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(Constants.primary)
        }
        .padding(.leading, 8)
    }
    
    private var rightArrow: some View {
        Button {
            self.campus = viewModel.moveToNextCampus(currentCampus: self.campus)
        } label: {
            Image(systemName: "arrow.right")
                .foregroundColor(Constants.primary)
        }
        .padding(.trailing, 8)
    }
    
    private func campusContent(_ campus: Campus) -> some View {
        VStack {
            name(with: campus)
            address(with: campus)
            country(with: campus)
            
            VStack(alignment: .leading) {
                phone(with: campus)
                whatsapp(with: campus)
            }
            
            pastor(with: campus)
        }
    }
    
    private func name(with campus: Campus) -> some View {
        HStack {
            Text("campus ")
                .foregroundColor(Constants.primary)
                .font(.callout) +
            Text(campus.name ?? "")
                .foregroundColor(.accent)
                .font(.title)
        }
    }
    
    private func address(with campus: Campus) -> some View {
        Text(campus.address ?? "")
            .font(.footnote)
            .multilineTextAlignment(.center)
    }
    
    private func country(with campus: Campus) -> some View {
        Text(campus.country ?? "")
            .font(.callout)
            .padding(.bottom, 4)
    }
    
    private func phone(with campus: Campus) -> some View {
        HStack {
            Image(systemName: "phone.fill")
                .font(.caption)
                .foregroundColor(Constants.primary)
            
            Text(campus.phone ?? "")
                .foregroundColor(.accent)
                .font(.caption)
            
            Image(systemName: "doc.on.doc")
                .font(.caption)
                .foregroundColor(.accent)
        }
        .padding(.bottom, 4)
        .onTapGesture {
            pasteboard.string = campus.phone
        }
    }
    
    @ViewBuilder
    private func whatsapp(with campus: Campus) -> some View {
        let whatsapp = campus.whatsapp?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if let url = URL(string: "https://wa.me/" + whatsapp + "/?text=Los visito desde la App 💬") {
            Link(destination: url, label: {
                HStack {
                    Image(systemName: "message.fill")
                        .font(.caption)
                        .foregroundColor(Constants.primary)
                    
                    Text(campus.whatsapp ?? "")
                        .foregroundColor(.accent)
                        .font(.caption)
                    
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundColor(.accent)
                }
            })
            .padding(.bottom, 8)
        }
    }
    
    @ViewBuilder
    private func generalPastor(with pastor: Pastor) -> some View {
        VStack {
            AsyncImage(url: URL(string: pastor.image ?? "")) { image in
                image.resizable().centerCropped()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .foregroundColor(.white)
            .background(Color.green)
            .clipShape(Circle())
            
            HStack {
                Text(pastor.name ?? "")
                    .foregroundColor(.accent)
                    .font(.caption) +
                
                Text(pastor.lastname ?? "")
                    .foregroundColor(Constants.primary)
                    .font(.caption)
            }
            
            Text(pastor.rol ?? "")
                .foregroundColor(Constants.secondary)
                .font(.caption2)
        }
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private func pastor(with campus: Campus) -> some View {
        VStack {
            AsyncImage(url: URL(string: campus.pastorImage ?? "")) { image in
                image.resizable().centerCropped()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .foregroundColor(.white)
            .background(Color.green)
            .clipShape(Circle())
            
            HStack {
                Text(campus.pastorName ?? "")
                    .foregroundColor(.accent)
                    .font(.caption) +
                
                Text(campus.pastorLastname ?? "")
                    .foregroundColor(Constants.primary)
                    .font(.caption)
            }
            
            Text("Pastor")
                .foregroundColor(Constants.secondary)
                .font(.caption2)
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    CampusView(viewModel: CampusViewModel())
        .preferredColorScheme(.dark)
}
