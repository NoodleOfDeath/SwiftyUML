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
public protocol UMLGraphComponent {
    
    /// Constructs a new UML graph model component.
    init(id: String)
    
}

extension UMLGraph {
    
    ///
    public enum AttributeKey: String, Codable {
        case font
    }
    
    /// Base model of a component in a UML graph.
    open class Component<Model: UMLGraphModelComponent>: UIView, UMLGraphComponent, Codable {
        
        public enum CodingKeys: String, CodingKey {
            case model
            case attributes
        }
        
        // MARK: - Instance Properties
        
        /// UML graph model this component belongs to.
        open weak var graph: UMLGraph?
        
        /// Model of this UML graph node.
        open var model: Model
        
        /// Id of this component.
        open var id: String { return model.id }
        
        /// Display attribute of this UML graph node.
        open lazy var attributes = [AttributeKey: String]()
        
        // MARK: - Constructor Methods
        
        public required init(id: String) {
            model = Model(id: id)
            super.init(frame: .zero)
            loadFromModel()
        }
        
        public init(model: Model) {
            self.model = model
            super.init(frame: .zero)
            loadFromModel()
        }
        
        // MARK: - NSCoding Constructor Methods
        
        public required init?(coder aDecoder: NSCoder) {
            guard
                let model = aDecoder.decodeObject(forKey: CodingKeys.model.stringValue) as? Model,
                let attributes = aDecoder.decodeObject(forKey: CodingKeys.attributes.stringValue) as? [AttributeKey: String]
                else { return nil }
            self.model = model
            super.init(coder: aDecoder)
            self.attributes = attributes
            loadFromModel()
        }
        
        // MARK: - Decodable Constructor Methods
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            model = try values.decode(Model.self, forKey: .model)
            super.init(frame: .zero)
            attributes = try values.decode([AttributeKey: String].self, forKey: .attributes)
            loadFromModel()
        }
        
        // MARK: - NSCoding Methods
        
        override open func encode(with aCoder: NSCoder) {
            super.encode(with: aCoder)
            aCoder.encode(model, forKey: CodingKeys.model.stringValue)
            aCoder.encode(attributes, forKey: CodingKeys.attributes.stringValue)
        }
        
        // MARK: - Encodable Methods
        
        open func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(model, forKey: .model)
            try container.encode(attributes, forKey: .attributes)
        }
        
        // MARK: - UIView Methods
        
        override open func draw(_ rect: CGRect) {
            super.draw(rect)
            
        }
        
        // MARK: - Instance Methods
        
        /// Loads this node from its model object.
        open func loadFromModel() {
            
        }
        
    }
    
}
