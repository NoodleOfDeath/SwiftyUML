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

import UIKit

import SnapKit

@objc(UMLGraphDelegate)
public protocol UMLGraphDelegate {
    
    @objc optional
    func graph(_ graph: UMLGraph, didAdd component: UMLGraphComponent)
    
    @objc optional
    func graph(_ graph: UMLGraph, didRemove component: UMLGraphComponent?)
    
}

/// Base view implementation for a UML graph.
open class UMLGraph: UIView, Codable {
    
    /// Coding keys used for encoding/decoding instances of this class.
    public enum CodingKeys: String, CodingKey {
        case model
    }
    
    // MARK: - Instance Propertoes
    
    /// Delegate of this graph.
    open var delegate: UMLGraphDelegate?
    
    /// Model of of this UML graph.
    open var model: UMLGraphModel
    
    /// Nodes of this UML graph.
    open var nodeMap = [String: Node]()
    
    /// Links of this UML graph.
    open var linkMap = [String: [String: Link]]()
    
    // MARK: - Constructor Methods
    
    /// Constructs a new UML graph instance with an initial UML graph model.
    ///
    /// - Parameters:
    ///     - model: of the new UML graph.
    public required init(model: UMLGraphModel = UMLGraphModel()) {
        self.model = model
        super.init(frame: .zero)
        loadFromModel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let model = aDecoder.decodeObject(forKey: CodingKeys.model.stringValue) as? UMLGraphModel else { return nil }
        self.model = model
        super.init(coder: aDecoder)
        loadFromModel()
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        model = try values.decode(UMLGraphModel.self, forKey: .model)
        super.init(frame: .zero)
        loadFromModel()
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(model, forKey: CodingKeys.model.stringValue)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
    }
    
    // MARK: - UIView Methods
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    // MARK: - Instance Methods
    
    public subscript (id: String) -> Node? {
        get { return nodeMap[id] }
        set { nodeMap[id] = newValue }
    }
    
    public subscript (ids: (String?, String?)) -> Link? {
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
    
    /// Loads from the model of this UML graph.
    open func loadFromModel() {
        for nodeModel in model.nodes {
            let node = Node(model: nodeModel)
            node.loadFromModel()
            add(node: node)
        }
        for linkModel in model.links {
            let link = Link(model: linkModel)
            link.loadFromModel()
            add(link: link)
        }
    }
    
    /// Adds a node to this UML graph.
    open func add(node: Node) {
        node.graph = self
        nodeMap[node.id] = node
        addSubview(node)
        model.add(node: node.model)
        delegate?.graph?(self, didAdd: node)
    }
    
    /// Adds a node to this UML graph.
    open func add(node model: UMLGraphModel.NodeModel) {
        add(node: Node(model: model))
    }
    
    /// Adds a link to this UML graph.
    open func add(link: Link) {
        link.graph = self
        addSubview(link)
        model.add(link: link.model)
        delegate?.graph?(self, didAdd: link)
    }
    
    /// Adds a link to this UML graph.
    open func add(link model: UMLGraphModel.LinkModel) {
        add(link: Link(model: model))
    }
    
    /// Removes a node from this UML graph.
    open func remove(node: Node) {
        nodeMap[node.id] = nil
        node.removeFromSuperview()
        model.remove(node: node.model)
        delegate?.graph?(self, didRemove: node)
    }
    
    /// Removes a node from this UML graph.
    open func remove(node model: UMLGraphModel.NodeModel) {
        guard let node = nodeMap[model.id] else { return }
        remove(node: node)
    }
    
    /// Removes a link from this UML graph.
    open func remove(link: Link) {
        self[(link.sourceNodeId, link.targetNodeId)] = nil
        link.removeFromSuperview()
        model.remove(link: link.model)
        delegate?.graph?(self, didRemove: link)
    }
    
    /// Removes a link from this UML graph.
    open func remove(link model: UMLGraphModel.LinkModel) {
        guard let link = self[(model.sourceNodeId, model.targetNodeId)] else { return }
        remove(link: link)
    }
    
}
