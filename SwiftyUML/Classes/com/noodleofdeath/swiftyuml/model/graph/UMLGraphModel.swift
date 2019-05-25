//
// The MIT License (MIT)
//
// Copyright © 2019 NoodleOfDeath. All rights reserved.
// NoodleOfDeath
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

@objc
public protocol UMLGraphModelDelegate {
    
    @objc optional
    func graphModel(_ graphModel: UMLGraphModel, didAdd componentModel: UMLGraphModel.ComponentModel)
    
    @objc optional
    func graphModel(_ graphModel: UMLGraphModel, didRemove componentModel: UMLGraphModel.ComponentModel?)
    
}

/// Base model data structure for a UML graph.
@objc
open class UMLGraphModel: NSObject, Codable, NSCoding {
    
    /// Coding keys used for encoding/decoding instances of this class.
    public enum CodingKeys: String, CodingKey {
        case nodeMap
        case linkMap
    }
    
    public typealias This = UMLGraphModel
    
    // MARK: - Instance Methods
    
    /// Delegate of this graph model.
    open var delegate: UMLGraphModelDelegate?
    
    /// Node model map of this UML graph model.
    open var nodeMap = [String: NodeModel]() {
        didSet { _nodes = nil }
    }
    
    /// Link model map of this UML graph model.
    open var linkMap = [String: [String: LinkModel]]() {
        didSet { _links = nil }
    }
    
    fileprivate var _nodes: [NodeModel]?
    
    /// Nodes of this UML graph model.
    open var nodes: [NodeModel] {
        get {
            if _nodes == nil { _nodes = nodeMap.map { $0.value } }
            return _nodes!
        }
        set { _nodes = newValue }
    }
    
    fileprivate var _links: [LinkModel]?
    
    /// Links of this UML map.
    open var links: [LinkModel] {
        get {
            if _links == nil {
                var links = [LinkModel]()
                linkMap.forEach {
                    links.append(contentsOf: $0.value.map { $0.value })
                }
                _links = links
            }
            return _links!
        }
        set { _links = newValue }
    }
    
    // MARK: - Constructor Methods
    
    public required init(nodeMap: [String: NodeModel]? = nil, linkMap: [String: [String: LinkModel]]? = nil) {
        self.nodeMap = nodeMap ?? [:]
        self.linkMap = linkMap ?? [:]
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let nodeMap = aDecoder.decodeObject(forKey: CodingKeys.nodeMap.rawValue) as? [String: NodeModel] else { return nil }
        guard let linkMap = aDecoder.decodeObject(forKey: CodingKeys.linkMap.rawValue) as? [String: [String: LinkModel]] else { return nil }
        self.nodeMap = nodeMap
        self.linkMap = linkMap
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(nodeMap, forKey: CodingKeys.nodeMap.rawValue)
        aCoder.encode(linkMap, forKey: CodingKeys.linkMap.rawValue)
    }
    
    // MARK: - Instance Methods
    
    public subscript (id: String) -> NodeModel? {
        get { return nodeMap[id] }
        set { nodeMap[id] = newValue }
    }
    
    public subscript (ids: (String?, String?)) -> LinkModel? {
        get {
            guard let sourceId = ids.0, let targetId = ids.1 else { return nil }
            return linkMap[sourceId]?[targetId]
        }
        set {
            guard let sourceId = ids.0, let targetId = ids.1 else { return }
            if linkMap[sourceId] != nil {
                linkMap[sourceId]?[targetId] = newValue
            } else {
                guard let newValue = newValue else { return }
                linkMap[sourceId] = [targetId: newValue]
            }
        }
    }
    
    /// Adds a node to this UML graph model.
    open func add(node: NodeModel) {
        nodeMap[node.id] = node
        delegate?.graphModel?(self, didAdd: node)
    }
    
    /// Removes a node from this UML graph model.
    open func remove(node: NodeModel) {
        nodeMap[node.id] = nil
        delegate?.graphModel?(self, didRemove: node)
    }
    
    /// Adds a link to this UML graph model.
    open func add(link: LinkModel) {
        link.source?.add(outgoingLink: link.target)
        link.target?.add(incomingLink: link.source)
        self[(link.sourceNodeId, link.targetNodeId)] = link
        delegate?.graphModel?(self, didAdd: link)
    }
    
    /// Removes a link from this UML graph model.
    open func remove(link: LinkModel) {
        link.source?.remove(outgoingLink: link.target)
        link.target?.remove(incomingLink: link.source)
        self[(link.sourceNodeId, link.targetNodeId)] = nil
        delegate?.graphModel?(self, didRemove: link)
    }
    
}
