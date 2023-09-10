//
//  SaveToSongBookViewController.swift
//  krk-share-iOS
//
//  Created by John Patrick Teruel on 9/8/23.
//

import UIKit

class SaveToSongBookViewController: UIViewController {
    @IBOutlet weak var sourceLabel: UILabel!
    
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
    @discardableResult
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
        self.updateSourceLabel(url.absoluteString)
    }
    
    func updateSourceLabel(_ text: String) {
        DispatchQueue.main.async {
            self.sourceLabel.text = text
        }
    }
}
