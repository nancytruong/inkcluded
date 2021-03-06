//
//  CanvasModel.swift
//  inkcluded-405
//
//  Created by Francis Yuen on 2/21/17.
//  Copyright © 2017 Boba. All rights reserved.
//

import Foundation

class CanvasModel {
    let WILL_DOCUMENT_NAME = "document.will"
    var canvasElements: [AnyObject]
    
    init() {
        self.canvasElements = []
    }
    
    func appendElement(elem: AnyObject) {
        canvasElements.append(elem)
    }
    
    func clearCanvasElements() {
        canvasElements.removeAll()
    }
    
    func getCanvasElements() -> [AnyObject] {
        return canvasElements
    }
    
    func popMostRecentElement() -> AnyObject! {
        return canvasElements.popLast()
    }
    
    func saveCanvasElements(drawViewSize: CGSize, toFile path: String) -> Bool {
        let inkEncoder = WCMInkEncoder()
        let doc = WCMDocument()
        let section = WCMDocumentSection()
        
        // set the size of the section
        section.size = drawViewSize
        for elem in canvasElements {
            // if the element is a stroke
            if let strokeElem = elem as? Stroke {
                inkEncoder.encodePath(
                    withPrecision: 2,
                    andPoints: strokeElem.points,
                    andStride: UInt32(strokeElem.stride),
                    andWidth: strokeElem.width,
                    andColor: strokeElem.color,
                    andTs: 0,
                    andTf: 1,
                    andBlendMode: WCMBlendMode.normal
                )
                let inkData = inkEncoder.getBytes()
                let path = WCMDocumentSectionPaths()
                path.content.setData(inkData, with: WCMDocumentContentType.strokes())
                
                // add it to the section
                section.add(path)
            }
            // if the element is a imageView
            else if let imageElem = elem as? DraggableImageView {
                let imageData = UIImagePNGRepresentation(imageElem.image!)
                let willImage = WCMDocumentSectionImage()
                willImage.content.setData(imageData, with: WCMDocumentContentType.png())
                willImage.rect = imageElem.frame
                
                // add it to the section
                section.add(willImage)
            }
            else if let textElement = elem as? DraggableTextView {
                let textData = textElement.text?.data(using: .utf8)?.base64EncodedData()
                let willImageWrapper = WCMDocumentSectionImage()
                let mimeType = WCMDocumentContentType.getByMimeType("image/jpeg")
                willImageWrapper.content.setData(textData, with: mimeType)
                willImageWrapper.rect = textElement.frame
                
                section.add(willImageWrapper)
            }
            else {
                print("Not expecting this type yet")
                print(elem.self)
            }
        }
        
        // Add section to document
        doc.sections.add(section)
        
        // Create and write to the file
        print("CanvasElement Finished")
        return doc.createDocument(atPath: path)
    }
    
    func restoreState(fromElements elements: [AnyObject]) {
        self.canvasElements.append(contentsOf: elements)
    }
    
    static func decodeObjectsFromWillFile(textViewDelegate: UITextViewDelegate!, atPath path: String) -> ([AnyObject]?, CGSize)! {
        let doc = WCMDocument()
        var elements: [AnyObject] = []
        
        if !(doc.load(atPath: path)) {
            return nil
        }
        
        if doc.sections == nil {
            return nil
        }
        
        let section = doc.sections![0] as! WCMDocumentSection
        
        for element in section.subelements {
            if let strokeElement = element as? WCMDocumentSectionPaths {
                let inkData = strokeElement.content.loadData()
                let decoder = WCMInkDecoder(data: inkData)
                
                var strokePoints: WCMFloatVector? = WCMFloatVector()
                var strokeStride: UInt32 = UInt32()
                var strokeWidth: Float = Float()
                var strokeColor: UIColor? = UIColor()
                var strokeStartValue: Float = Float()
                var strokeFinishValue: Float = Float()
                var blendMode: WCMBlendMode = WCMBlendMode(rawValue: 0)!
                
                while (decoder?.decodePath(
                    toPoints: &strokePoints,
                    andStride: &strokeStride,
                    andWidth: &strokeWidth,
                    andColor: &strokeColor,
                    andTs: &strokeStartValue,
                    andTf: &strokeFinishValue,
                    andBlendMode: &blendMode))!{};
                
                let stroke = Stroke(
                points: strokePoints,
                andStride: Int32(strokeStride),
                andWidth: strokeWidth,
                andColor: strokeColor,
                andTs: strokeStartValue,
                andTf: strokeFinishValue,
                andBlendMode: blendMode
                )
                
                elements.append(stroke!)
            }
            else if let imageElement = element as? WCMDocumentSectionImage {
                if (imageElement.content.type.isEqual(WCMDocumentContentType.png())) {
                    let imageData = imageElement.content.loadData()
                    let image = UIImage(data: imageData!)
                    let imageView = DraggableImageView(image: image)
                    imageView.frame = imageElement.rect
                    
                    elements.append(imageView)
                }
                else {
                    if let decodedData = Data(base64Encoded: imageElement.content.loadData()),
                        let decodedString = String(data: decodedData, encoding: .utf8) {
                        let textField = DraggableTextView(frame: imageElement.rect)
                        textField.delegate = textViewDelegate
                        textField.text = decodedString
                        
                        elements.append(textField)
                    }
                }
            }
            else {
                print("Not expecting this type")
            }
        }
        
        return (elements, section.size)
    }
}
