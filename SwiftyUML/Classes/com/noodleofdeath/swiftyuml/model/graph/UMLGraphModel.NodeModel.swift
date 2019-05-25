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

extension UMLGraphModel {
    
    /// Base model of a node in a UML graph.
    @objc(UMLGraphModleNodeModel)
    open class NodeModel: ComponentModel {
        
        /// Coding keys used for encoding/decoding instances of this class.
        public enum CodingKeys: String, CodingKey {
            case id
            case incomingLinks
            case outgoingLinks
        }

        // MARK: - Instance Properties
        
        // Ids of nodes with links listing this node as the destination node.
        open var incomingLinks: [String]
        
        // Ids of nodes with links listing this node as the source node.
        public var outgoingLinks: [String]
        
        // MARK: - Constructor Methods
        
        public required init(id: String) {
            self.incomingLinks = []
            self.outgoingLinks = []
            super.init(id: id)
        }
        
        public required init(id: String, incomingLinks: [String]? = nil, outgoingLinks: [String]? = nil) {
            self.incomingLinks = incomingLinks ?? []
            self.outgoingLinks = outgoingLinks ?? []
            super.init(id: id)
        }
        
        public required init?(coder aDecoder: NSCoder) {
            guard let incomingLinks = aDecoder.decodeObject(forKey: CodingKeys.incomingLinks.stringValue) as? [String] else { return nil }
            guard let outgoingLinks = aDecoder.decodeObject(forKey: CodingKeys.outgoingLinks.stringValue) as? [String] else { return nil }
            self.incomingLinks = incomingLinks
            self.outgoingLinks = outgoingLinks
            super.init(coder: aDecoder)
        }
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            incomingLinks = try values.decode([String].self, forKey: .incomingLinks)
            outgoingLinks = try values.decode([String].self, forKey: .outgoingLinks)
            try super.init(from: decoder)
        }
        
        override open func encode(with aCoder: NSCoder) {
            super.encode(with: aCoder)
            aCoder.encode(incomingLinks, forKey: CodingKeys.incomingLinks.stringValue)
            aCoder.encode(outgoingLinks, forKey: CodingKeys.outgoingLinks.stringValue)
        }
        
        override open func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(incomingLinks, forKey: .incomingLinks)
            try container.encode(outgoingLinks, forKey: .outgoingLinks)
        }
        
        // MARK: - Instance Methods
        
        ///
        open func add(incomingLink: String) {
            incomingLinks.append(incomingLink)
        }
        
        ///
        open func add(incomingLink: NodeModel?) {
            guard let incomingLink = incomingLink else { return }
            incomingLinks.append(incomingLink.id)
        }
        
        ///
        open func remove(incomingLink: String?) {
            incomingLinks.removeAll { $0 == incomingLink }
        }
        
        ///
        open func remove(incomingLink: NodeModel?) {
            incomingLinks.removeAll { $0 == incomingLink?.id }
        }
        
        ///
        open func add(outgoingLink: String) {
            outgoingLinks.append(outgoingLink)
        }
        
        ///
        open func add(outgoingLink: NodeModel?) {
            guard let outgoingLink = outgoingLink else { return }
            outgoingLinks.append(outgoingLink.id)
        }
        
        ///
        open func remove(outgoingLink: String?) {
            outgoingLinks.removeAll { $0 == outgoingLink }
        }
        
        ///
        open func remove(outgoingLink: NodeModel?) {
            outgoingLinks.removeAll { $0 == outgoingLink?.id }
        }
        
    }
    
}
