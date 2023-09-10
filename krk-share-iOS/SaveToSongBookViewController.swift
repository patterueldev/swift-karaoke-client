//
//  SaveToSongBookViewController.swift
//  krk-share-iOS
//
//  Created by John Patrick Teruel on 9/8/23.
//

import UIKit
import SwiftSoup

class SaveToSongBookViewController: UIViewController {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var songDetailsContainer: UIStackView!
    @IBOutlet weak var songTitleField: UITextField!
    @IBOutlet weak var songArtistField: UITextField!
    @IBOutlet weak var songLanguageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // just for test
        self.sourceLabel.text = "https://www.youtube.com/watch?v=abcd1234"
        // Access the NSExtensionContext
        if let context = self.extensionContext {
            // Get the attachments
            if let items = context.inputItems as? [NSExtensionItem] {
                for item in items {
                    if let attachments = item.attachments {
                        for attachment in attachments {
                            // Check if the attachment contains a URL
                            if attachment.hasItemConformingToTypeIdentifier("public.url") {
                                attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                                    if let sharedURL = url as? URL {
                                        // Process the shared URL
                                        self.updateUrl(with: sharedURL.absoluteString)
                                    }
                                }
                            } else if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
                                attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { (text, error) in
                                    if let sharedText = text as? String {
                                        // Process the shared plain text
                                        self.updateUrl(with: sharedText)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.configureNavigationButtons()
    }
    
    func configureNavigationButtons() {
        self.setCancelBarButtonItem()
        self.setSaveBarButtonItem()
    }
    
    func setCancelBarButtonItem() {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    func setSaveBarButtonItem() {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    @objc func cancelButtonTapped() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @objc func saveButtonTapped() {
        let url: String = self.sourceLabel.text ?? ""
        guard let encodedURLString = manuallyPercentEncodeURL(url) else {
            UIPasteboard.general.string = url
            return
        }
        let redirectUrl = "krkios://download/?url=\(encodedURLString)"
        guard let url = URL(string: redirectUrl) else {
            UIPasteboard.general.string = redirectUrl
            return
        }
        print("Opening URL: \(url)")
        self.openURL(url)
    }

    // Courtesy: https://stackoverflow.com/a/44499222/13363449 👇🏾
    // Function must be named exactly like this so a selector can be found by the compiler!
    // Anyway - it's another selector in another instance that would be "performed" instead.
    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    func manuallyPercentEncodeURL(_ urlString: String) -> String? {
        guard let urlComponents = URLComponents(string: urlString) else {
            return nil
        }

        let encodedScheme = urlComponents.scheme?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedHost = urlComponents.host?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedPath = urlComponents.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let encodedQuery = urlComponents.query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let debuggable = """
        encodedScheme: \(encodedScheme)
        encodedHost: \(encodedHost)
        encodedPath: \(encodedPath)
        encodedQuery: \(encodedQuery)
        
        """
        
        var encodedURL = ""
        
        if !encodedScheme.isEmpty {
            encodedURL += encodedScheme + "://"
        }
        
        if !encodedHost.isEmpty {
            encodedURL += encodedHost
        }
        
        if !encodedPath.isEmpty {
            encodedURL += encodedPath
        }
        
        if !encodedQuery.isEmpty {
            encodedURL += "?" + encodedQuery
        }
        
        return encodedURL
    }
    
    func updateUrl(with text: String) {
        guard let url = URL(string: text) else {
            return
        }
        // try to get the video's title from the <title> tag
        Task {
            let title = try await getTitleFromYouTubeURL(url)
            DispatchQueue.main.async {
                self.songTitleField.text = title
            }
        }
        self.updateSourceLabel(url.absoluteString)
    }
    
    func updateSourceLabel(_ text: String) {
        DispatchQueue.main.async {
            self.sourceLabel.text = text
        }
    }
    
    func getTitleFromYouTubeURL(_ url: URL) async throws -> String? {
        // Create a URLSession to fetch the HTML content
        let session = URLSession.shared

        do {
            // Fetch the HTML content asynchronously
            let (data, _) = try await session.data(from: url)

            // Convert the data to a string
            if let htmlString = String(data: data, encoding: .utf8) {
                // Extract the video title asynchronously
                let title = try await extractTitleFromHTML(htmlString)
                return title
            }
        } catch {
            print("Error fetching or parsing HTML: \(error)")
        }

        return nil
    }

    // Function to extract the video title from HTML content
    func extractTitleFromHTML(_ htmlString: String) async throws -> String? {
        // Implement the logic to extract the video title from the HTML content.
        // You can use regular expressions or HTML parsing libraries like SwiftSoup.

        // Example using SwiftSoup (you need to add SwiftSoup to your project):
        do {
            let doc = try SwiftSoup.parse(htmlString)
            let titleElement = try doc.select("title").first()
            let title = try titleElement?.text()
            return title
        } catch {
            throw error
        }
    }
        
    
}
