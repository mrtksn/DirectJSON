//
//  JSON.swift
//
//  Created by Mertol Kasanan on 17/12/2022.
//

import Foundation

/// The JSON Object enables you to access the values by keypaths and convert them to Swift Types.
/// You can use the .jsonDecode() to decode the values to anything Codable and you can use a custom decoder.
///
/// The compiler deducts the types from the clues you give. When accessing properties, if you don't provide a type it will assume you want to get a JSON object(if does not exist will return empty JSON Dictonary). If you provide a Type, make it optional because the JSON may not contain it.
///```
/// //You can work with any String that is a valid JSON String. Let's look at the following:
///let countryData = "{\"name\" : \"Türkiye\", \"population\" : 85000000, \"tags\" : [\"Europe\", \"Asia\", \"Middle East\"] }"
///
/// //Access a property value
/// let name : String? = countryData.json.name
///
/// //Access a property value as any Codable Swift Type
/// let population : Int? = countryData.json.population
///
/// //Access a property using a custom Decoder
/// let population : Int? = countryData.json.population.jsonDecode(myCustomDecoder)
///
/// //You can convert the JSON String directly to any Codable Swift Type
/// let country : Country? = countryData.json.jsonDecode()
///
/// //Access an array value with index
/// let firstTag : String? = countryData.json.tags[0]
///
///
///```
///
@dynamicMemberLookup
public enum JSON: Codable {
    case boolType(Bool)
    case doubleType(Double)
    case stringType(String)
    case arrayType([JSON])
    case dictionaryType([String: JSON])
    
    
    public struct JSONCodingKeys: CodingKey {
        public var stringValue: String
        public var intValue: Int?
        
        
        public init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        public init?(intValue: Int) {
            self.init(stringValue: "\(intValue)")
            self.intValue = intValue
        }
    }
    
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            self = JSON(from: container)
        } else if let container = try? decoder.unkeyedContainer() {
            self = JSON(from: container)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "failed to decode"))
        }
    }
    
    private init(from container: KeyedDecodingContainer<JSONCodingKeys>) {
        var dict: [String: JSON] = [:]
        for key in container.allKeys {
            if let value = try? container.decode(Bool.self, forKey: key) {
                dict[key.stringValue] = .boolType(value)
            } else if let value = try? container.decode(Double.self, forKey: key) {
                dict[key.stringValue] = .doubleType(value)
            } else if let value = try? container.decode(String.self, forKey: key) {
                dict[key.stringValue] = .stringType(value)
            } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
                dict[key.stringValue] = JSON(from: value)
            } else if let value = try? container.nestedUnkeyedContainer(forKey: key) {
                dict[key.stringValue] = JSON(from: value)
            }
        }
        self = .dictionaryType(dict)
    }
    
    private init(from container: UnkeyedDecodingContainer) {
        var container = container
        var arr: [JSON] = []
        while !container.isAtEnd {
            if let value = try? container.decode(Bool.self) {
                arr.append(.boolType(value))
            } else if let value = try? container.decode(Double.self) {
                arr.append(.doubleType(value))
            } else if let value = try? container.decode(String.self) {
                arr.append(.stringType(value))
            } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
                arr.append(JSON(from: value))
            } else if let value = try? container.nestedUnkeyedContainer() {
                arr.append(JSON(from: value))
            }
        }
        self = .arrayType(arr)
    }
    
    public enum CodingKeys: CodingKey {
        case boolType
        case doubleType
        case stringType
        case arrayType
        case dictionaryType
    }
    
    enum BoolTypeCodingKeys: CodingKey {
        case _0
    }
    
    enum DoubleTypeCodingKeys: CodingKey {
        case _0
    }
    
    enum StringTypeCodingKeys: CodingKey {
        case _0
    }
    
    enum ArrayTypeCodingKeys: CodingKey {
        case _0
    }
    
    enum DictionaryTypeCodingKeys: CodingKey {
        case _0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .boolType(let a0):
            var nestedContainer = container.nestedContainer(keyedBy: JSON.BoolTypeCodingKeys.self, forKey: .boolType)
            try nestedContainer.encode(a0, forKey: JSON.BoolTypeCodingKeys._0)
        case .doubleType(let a0):
            var nestedContainer = container.nestedContainer(keyedBy: JSON.DoubleTypeCodingKeys.self, forKey: .doubleType)
            try nestedContainer.encode(a0, forKey: JSON.DoubleTypeCodingKeys._0)
        case .stringType(let a0):
            var nestedContainer = container.nestedContainer(keyedBy: JSON.StringTypeCodingKeys.self, forKey: .stringType)
            try nestedContainer.encode(a0, forKey: JSON.StringTypeCodingKeys._0)
        case .arrayType(let a0):
            var nestedContainer = container.nestedContainer(keyedBy: JSON.ArrayTypeCodingKeys.self, forKey: .arrayType)
            try nestedContainer.encode(a0, forKey: JSON.ArrayTypeCodingKeys._0)
        case .dictionaryType(let a0):
            var nestedContainer = container.nestedContainer(keyedBy: JSON.DictionaryTypeCodingKeys.self, forKey: .dictionaryType)
            try nestedContainer.encode(a0, forKey: JSON.DictionaryTypeCodingKeys._0)
        }
    }
    
    
    /*
     Subscripts used to access data by keypaths etc.
     */
    public subscript(dynamicMember member : String)->JSON{
        return getValueForKey(key: member)
    }
    
    public subscript<T : Codable>(dynamicMember member : String)->T?{
        let result : T? = getDecodedValueForKey(key: member)
        return result
    }

    public subscript(key : String)->JSON{
        getValueForKey(key: key)
    }
    
    public subscript<T : Codable>(key : String)->T?{
        getDecodedValueForKey(key: key)
    }

    
    public subscript(index : Int)->JSON{
        switch self {
        case .arrayType(let arr):
            guard index <= arr.count - 1 else {return .dictionaryType([String : JSON]())}
            return arr[index]
        default:
            return .dictionaryType([String : JSON]())
        }
    }
    
    
    public subscript<T : Codable>(index : Int)->T?{
        return self[index].getValue() as? T
    }

    
    private func getValueForKey(key : String)->JSON{
        let emptyJSON = JSON.dictionaryType([String : JSON]())
        switch self {
        case .boolType(let bool):
            guard let jsonData = "\(bool)".data(using: .utf8) else { return emptyJSON}
            return (try? JSONDecoder().decode(Self.self, from: jsonData)) ?? emptyJSON
        case .doubleType(let double):
            guard let jsonData = "\(double)".data(using: .utf8) else { return emptyJSON}
            return (try? JSONDecoder().decode(Self.self, from: jsonData)) ?? emptyJSON
        case .stringType(let string):
            guard let jsonData = "\"\(string)\"".data(using: .utf8) else { return emptyJSON}
            return (try? JSONDecoder().decode(Self.self, from: jsonData)) ?? emptyJSON
        case .arrayType(_):
            return self
        case .dictionaryType(let dictionary):
            return dictionary[key] ?? emptyJSON
        }
    }
    
    private func getDecodedValueForKey<T : Codable>(key : String)->T?{
        switch self {
        case .dictionaryType(let dict):
            guard let val = dict[key] else {return nil}
            guard let str = Self.stringify(val) else {return nil}
            return try? JSONDecoder().decode(T.self, from: str.data(using: .utf8)!)
        default:
            return nil
        }
    }
    
    /// Convert the JSON Object back into a String
    /// - Parameter data: JSON object
    /// - Returns: String
    public static func stringify(_ data : JSON)->String?{
        switch data {
        case .boolType(let bool):
            return bool ? "true" : "false" //hmm it doesn't seem to activate
        case .doubleType(let double):
            return String(double)
        case .stringType(let string):
            return "\"\(string)\""
        case .arrayType(let arr):
            let openStr = "["
            let closeStr = "]"
            let contentStr = arr.reduce("",{
                guard let itemStr = self.stringify($1) else { return $0}
                return $0 + "," + itemStr
            })
            let result = openStr + String(contentStr.dropFirst()) + closeStr
            return result
        case .dictionaryType(let dict):
            
            let openStr = "{"
            let closeStr = "}"
            var contentStr = ""
            for key in dict.keys {
                if let val = dict[key], let strVal = self.stringify(val){
                    contentStr += ", \"\(key)\" : \(strVal)"
                }
            }
            
            let result = openStr + String(contentStr.dropFirst()) + closeStr
            return result
        }
    }
    
    /// Convert the JSON Object back into a String. Can be useful to extract a portion of a JSON String by first accessing a value through a keypath and then converting it into a JSON String.
    /// - Returns: String formatted as JSON
    public func stringify()->String?{
        return Self.stringify(self)
    }
    
    /// Turn any Encodable Swift Object into a JSON String
    /// - Parameter data: the object to encode
    /// - Parameter encoder: cusome encoder
    /// - Returns: a String formatted as a JSON
    static func encode(_ data : Encodable, encoder : JSONEncoder = .init()) throws ->String?{
        let jsonData = try encoder.encode(data)
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// decode to a Codable type. Can use custom decoder
    /// - Parameter decoder: If you like to use a custom Decoder
    /// - Returns: the decoded object
    public func jsonDecode<T : Codable>(decoder : JSONDecoder = .init())->T?{
        guard let data = self.stringify()?.data(using: .utf8) else {return nil}
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    /// Get the value of the current JSON Key directly.
    /// Note that JSON Types are  **String, Bool, Double** which means you need to first retrieve the values as one of these and then convert them to Swift types
    /// ```
    ///
    ///  let myJSONString = "{\"name\" : \"Tim Apple\", \"age\" : 50 }"
    ///
    /// //get a value from a JSON String in the Type you want:
    ///  let name = myJSONString.json.name.getValue() as? String
    ///
    /// //Note that JSON Types are: String, Bool, Double
    /// //If you need an Int for example, you can convert it from Double like this:
    ///
    ///  guard let ageValue = myJSONString.json.age.getValue() as? Double else {return}
    ///  let age = Int(ageValue)
    ///
    ///  ```
    /// - Returns: Any which can be a **String, Bool, Double**,  Dictionary<String, Any> or Array<Any>. If the value doesn't exist in the JSON, it will return empty Dictionary which will result as *nil* if you try to convert to any other type.
    public func getValue()->Any {
        switch self {
        case .dictionaryType(let dictionary):
            var result : [String : Any] = .init()
            for key in dictionary.keys {
                result[key] = dictionary[key]?.getValue()
            }
            return result
        case .arrayType(let arr):
            return arr.map({ $0.getValue()})
        case .stringType(let val):
            return val.self
        case .boolType(let val):
            return val.self
        case .doubleType(let val):
            return val.self
        }
    }
    
    
    
}

//You can work with any String that is a valid JSON String. Let's look at the following:
let countryData = "{\"name\" : \"Türkiye\", \"population\" : 85000000, \"tags\" : [\"Europe\", \"Asia\", \"Middle East\"] }"

//Access a property value
let name : String? = countryData.json.name

//Access an array value with index
let firstTag : String? = countryData.json.tags[0]

extension String {

    /// The JSON Object enables you to access the values by keypaths and convert them to Swift Types.
    /// You can use the .jsonDecode() to decode the values to anything Codable and you can use a custom decoder.
    ///
    /// The compiler deducts the types from the clues you give. When accessing properties, if you don't provide a type it will assume you want to get a JSON object(if does not exist will return empty JSON Dictonary). If you provide a Type, make it optional because the JSON may not contain it.
    ///```
    /// //You can work with any String that is a valid JSON String. Let's look at the following:
    ///let countryData = "{\"name\" : \"Türkiye\", \"population\" : 85000000, \"tags\" : [\"Europe\", \"Asia\", \"Middle East\"] }"
    ///
    /// //Access a property value
    /// let name : String? = countryData.json.name
    ///
    /// //Access a property value as any Codable Swift Type
    /// let population : Int? = countryData.json.population
    ///
    /// //Access a property using a custom Decoder
    /// let population : Int? = countryData.json.population.jsonDecode(myCustomDecoder)
    ///
    /// //You can convert the JSON String directly to any Codable Swift Type
    /// let country : Country? = countryData.json.jsonDecode()
    ///
    /// //Access an array value with index
    /// let firstTag : String? = countryData.json.tags[0]
    ///
    ///
    ///```
    ///
    public var json : JSON {
        get {
            (try? JSONDecoder().decode(JSON.self, from: self.data(using: .utf8)!)) ?? JSON.dictionaryType([String : JSON]())
        }
    }
    
    
    /// decode to JSON object using a custom decoder
    /// - Parameter decoder: the cusomized decoder
    /// - Returns: JSON object
    public func json(decoder : JSONDecoder)->JSON{
        (try? decoder.decode(JSON.self, from: self.data(using: .utf8)!)) ?? JSON.dictionaryType([String : JSON]())
    }
}
