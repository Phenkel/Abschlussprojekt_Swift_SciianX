//
//  RichPreviewViewModel.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.03.24.
//

import Foundation
import SwiftUI
import LinkPresentation

@MainActor
class RichPreviewViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var host: String?
    @Published private(set) var title: String?
    @Published private(set) var description: String?
    @Published private(set) var icon: UIImage?
    @Published private(set) var image: UIImage?
    @Published private(set) var videoUrl: URL?
    
    let number: String
    let url: URL
    
    init(_ urlSet: (number: String, url: URL)) {
        self.number = urlSet.number
        self.url = urlSet.url
        
        self.fetchMetadata()
    }
    
    private func fetchMetadata() {
        Task {
            do {
                let provider = LPMetadataProvider()
                let metadata = try await provider.startFetchingMetadata(for: self.url)
                
                self.host = self.url.host
                self.title = metadata.title
                self.description = metadata.value(forKey: "_summary") as? String
                
                if let iconData = await self.loadDataRepresentationImageAsync(metadata.iconProvider) {
                    await MainActor.run {
                        self.icon = UIImage(data: iconData)
                    }
                }
                
                if let imageData = await self.loadDataRepresentationImageAsync(metadata.imageProvider) {
                    await MainActor.run {
                        self.image = UIImage(data: imageData)
                    }
                }
                
                if let videoUrl = metadata.remoteVideoURL {
                    self.videoUrl = videoUrl
                }
            } catch {
                print("Failed fetching meta data for \(url.absoluteString): \(error)")
            }
        }
    }
    
    
     
    private func loadDataRepresentationImageAsync(_ provider: NSItemProvider?) async -> Data? {
        return await withUnsafeContinuation { continuation in
            if let provider {
                _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let error {
                        print("Failed fetching image data from metadata: \(error)")
                        continuation.resume(returning: nil)
                    }
                    
                    if let data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
        /*
        Future { promise in
            _ = provider?.loadDataRepresentation(for: .image) { data, error in
                if let data {
                    promise(.success(data))
                } else {
                    promise(.failure(error!))
                }
            }
        }
         */
    }
}

