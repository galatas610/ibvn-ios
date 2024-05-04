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
            Image("IbvnLogo")
                .resizable()
                .frame(width: 120, height: 31)
            
            HStack {
                pastor(with: campus)
                pastor(with: campus)
                pastor(with: campus)
            }
            
            Divider()
            
            HStack {
                leftArrow
                
                Spacer()
                
                campusContent(campus)
                
                Spacer()
                
                rightArrow
                
            }
            
            campusMap(with: campus)
            
        }
        .onChange(of: viewModel.campus ?? .init()) { campus in
            self.campus = campus.first ?? .init()
        }
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
            phone(with: campus)
            whatsapp(with: campus)
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
        if let url = URL(string: "https://wa.me/50325228106/?text=Los visito desde la App 💬") {
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
    private func pastor(with campus: Campus) -> some View {
        VStack {
            AsyncImage(url: URL(string: campus.pastorImage ?? "")) { image in
                image.resizable().centerCropped()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
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
            
            Text("pastor")
                .foregroundColor(Constants.secondary)
                .font(.caption2)
        }
        .padding(.bottom, 8)
    }
    
    private func campusMap(with campus: Campus) -> some View {
        @State var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: campus.latitude ?? 0,
                longitude: campus.longitude ?? 0),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01)
        )
        
        return Map(coordinateRegion: $region, annotationItems: viewModel.campusLocations) { loc in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)) {
                ZStack {
                    Image("logoShort")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 30, height: 30)
                    
                    Circle()
                        .strokeBorder(Constants.primary, lineWidth: 2)
                        .background(.clear)
                        .frame(width: 32, height: 32)
                }
                
                Text("Campus \n\(campus.name ?? "")")
                    .font(.caption2)
                    .foregroundColor(Constants.primary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    CampusView(viewModel: CampusViewModel())
        .preferredColorScheme(.dark)
}
