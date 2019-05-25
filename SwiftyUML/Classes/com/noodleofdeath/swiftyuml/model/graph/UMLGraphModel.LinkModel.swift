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
    
    /// Base model of a link in a UML graph.
    @objc(UMLGraphModelLinkModel)
    open class LinkModel: ComponentModel {
        
        ///
        public enum CodingKeys: String, CodingKey {
            case sourceNodeId
            case targetNodeId
        }
        
        // MARK: - Instance Properties
        
        /// Source node id of this link.
        open var sourceNodeId: String?
        
        /// Target node id of this link.
        open var targetNodeId: String?
        
        /// Source node of this link.
        open var source: NodeModel? {
            guard let sourceNodeId = sourceNodeId else { return nil }
            return graph?[sourceNodeId]
        }
        
        /// Target node of this link.
        open var target: NodeModel? {
            guard let targetNodeId = targetNodeId else { return nil }
            return graph?[targetNodeId]
        }
        
        // MARK: - Constructor Methods
        
        public required init(id: String) {
            self.sourceNodeId = "unknown"
            self.targetNodeId = "unknown"
            super.init(id: String(format: "%@, %@", "unknown", "unknown"))
        }
        
        ///
        public init(source: NodeModel, target: NodeModel) {
            self.sourceNodeId = source.id
            self.targetNodeId = target.id
            super.init(id: String(format: "%@, %@", source.id, target.id))
        }
        
        ///
        public init(sourceNodeId: String, targetNodeId: String) {
            self.sourceNodeId = sourceNodeId
            self.targetNodeId = targetNodeId
            super.init(id: String(format: "%@, %@", sourceNodeId, targetNodeId))
        }
        
        // MARK: - NSCoding Constructor Methods
        
        public required init?(coder aDecoder: NSCoder) {
            guard let sourceNodeId = aDecoder.decodeObject(forKey: CodingKeys.sourceNodeId.stringValue) as? String else { return nil }
            guard let targetNodeId = aDecoder.decodeObject(forKey: CodingKeys.targetNodeId.stringValue) as? String else { return nil }
            self.sourceNodeId = sourceNodeId
            self.targetNodeId = targetNodeId
            super.init(coder: aDecoder)
        }
        
        // MARK: - Decodable Constructor Methods
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            sourceNodeId = try values.decode(String.self, forKey: .sourceNodeId)
            targetNodeId = try values.decode(String.self, forKey: .targetNodeId)
            try super.init(from: decoder)
        }
        
        // MARK: - NSCoding Methods
        
        override open func encode(with aCoder: NSCoder) {
            super.encode(with: aCoder)
            aCoder.encode(sourceNodeId, forKey: CodingKeys.sourceNodeId.stringValue)
            aCoder.encode(targetNodeId, forKey: CodingKeys.targetNodeId.stringValue)
        }
        
        // MARK: - Encodable Methods
        
        override open func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(sourceNodeId, forKey: .sourceNodeId)
            try container.encode(targetNodeId, forKey: .targetNodeId)
        }
        
        // MARK: - Instance Methods
        
    }
    
}
