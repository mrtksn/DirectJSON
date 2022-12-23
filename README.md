# DirectJSON

A Swift package which enables you to **use JSON intuitively** as if in JavaScript. Just *use dots to access the JSON structure* like this:

```Swift
let brand : String? = theCarsOf2023.json.ev.popular[0].brand
```

###  Not much to learn
 DirectJSON will extend the String type and 
 you will be able to access any part of a JSON String through 
 the .json property. It's using *@dynamicMemberLookup* to decode the path you want to access.


You can work with any String that is a valid JSON String. Let's look at the following:

```Swift
// This is our JSON String 
let countryData = "{\"name\" : \"Türkiye\", \"facts\" : {\"population\" : 85000000, \"GDP\" : 815} , \"tags\" : [\"Europe\", \"Asia\", \"Middle East\"] }"
                  
            
//Access a property value
let name : String? = countryData.json.name
            
//Access a property value as any Codable Swift Type
let population : Int? = countryData.json.facts.population
            
//Access a property using a custom Decoder
let population : Int? = countryData.json.facts.population.jsonDecode(myCustomDecoder)
            
//You can convert the JSON String directly to any Codable Swift Type
let country : Country? = countryData.json.jsonDecode()
            
//Access array values using index
let firstTag : String? = countryData.json.tags[0]
```

### Comes with a few tools

The following API can be useful to streamline yourworkflow:

Turn any Swift object(that conforms to Codable) into a String

```Swift
 let car = try? JSON.encode(someCarObject)
 // result: {"brand" : "Tesla", "type" : "ev"}
```


Get a part of the JSON String as a String

```Swift
let evs = theCarsOf2023.json.ev.stringify()
// result: {"popular" : [car1, car2 ...], "topSpeed" : [car9, car3 ...]}
```

### Cookbook
Swift is a Typed language, JavaScript and consequently JSON are not. This creates hardships when converting from JavaScript into Swift. 

Here we will list ideas on how to solve some common issues like this.


Working with Arrays containing multiple types:

```Swift
let jobDescription = "{\"title\" : \"developer\", \"tags\" : [\"php\", \"js\", \"swift\", 2022, 2023]}"
                
var years = [Int]()
                
switch jobDescription.json.tags{
    case .arrayType(let arr):
        years = arr.compactMap({ $0.getValue() as? Double }).map({Int($0)})
    default:
        break
}
print("years:", years)
//result: years: [2022, 2023]

```
 
