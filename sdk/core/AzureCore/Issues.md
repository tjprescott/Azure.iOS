1. Non-class protocols cannot be marked @objc
2. Structs cannot be marked @objc
    - All structs will need to be converted to @objc compatible classes that derive from NSObject. Hits to speed and memory usage.
3. @objc protocol cannot refine non-@objc protocols
4. 
