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

public protocol UMLGraphModelComponent: Codable {
    
    /// Id of this component.
    var id: String { get }
    
    /// Constructs a new UML graph model component.
    init(id: String)
    
}

extension UMLGraphModel {
    
    /// Base model of a component in a UML graph.
    @objc(UMLGraphModelComponentModel)
    open class ComponentModel: NSObject, UMLGraphModelComponent, NSCoding {
        
        /// UML graph model this component belongs to.
        open weak var graph: UMLGraphModel?
        
        /// Unique id of this component.
        open var id: String
        
        /// Constructs a new component instance with a specified unique
        /// identifier.
        ///
        /// - Parameters:
        ///     - id: unique identifier of the new component.
        public required init(id: String) {
            self.id = id
            super.init()
        }
        
        // MARK: - NSCoding Constructor Methods
        
        public required init?(coder aDecoder: NSCoder) {
            guard let id = aDecoder.decodeObject(forKey: CodingKeys.id.stringValue) as? String else { return nil }
            self.id = id
            super.init()
        }
        
        // MARK: - NSCoding Methods
        
        open func encode(with aCoder: NSCoder) {
            aCoder.encode(id, forKey: CodingKeys.id.stringValue)
        }
        
    }
    
}
