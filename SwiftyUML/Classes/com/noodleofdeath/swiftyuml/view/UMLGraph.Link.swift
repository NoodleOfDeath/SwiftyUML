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

extension UMLGraph {
    
    /// Base view implementation for a UML graph node.
    open class Link: Component<UMLGraphModel.LinkModel> {
        
        // MARK: - Instance Properties
        
        open var sourceNodeId: String? {
            get { return model.sourceNodeId }
            set { model.sourceNodeId = newValue }
        }
        
        open var targetNodeId: String? {
            get { return model.targetNodeId }
            set { model.targetNodeId = newValue }
        }
        
        open var source: UMLGraphModel.NodeModel? {
            get { return model.source }
            set { sourceNodeId = newValue?.id }
        }
        
        open var target: UMLGraphModel.NodeModel? {
            get { return model.target }
            set { targetNodeId = newValue?.id  }
        }
        
        // MARK: - Constructor Methods
        
        public required init(id: String) {
            super.init(id: id)
        }
        
        public required override init(model: UMLGraphModel.LinkModel) {
            super.init(model: model)
        }
      
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        override open func encode(with aCoder: NSCoder) {
            super.encode(with: aCoder)
        }
        
        override open func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        
        // MARK: - UIView Methods
        
        override open func draw(_ rect: CGRect) {
            super.draw(rect)
            
        }
        
        // MARK: - Instance Methods
        
        /// Loads this node from its model object.
        override open func loadFromModel() {
            super.loadFromModel()
        }
        
    }
    
}
