 # DirectJSON

A Swift package that enables you to use JSON intuitively as if in JavaScript. 


You can work with any String that is a valid JSON String. Let's look at the following:

```Swift
    // This is our JSON String 
    let countryData = "{\"name\" : \"Türkiye\", \"population\" : 85000000, \"tags\" : [\"Europe\", \"Asia\", \"Middle East\"] }"
    
     //Access a property value
     let name : String? = countryData.json.name
    
     //Access a property value as any Codable Swift Type
     let population : Int? = countryData.json.population
    
     //Access a property using a custom Decoder
     let population : Int? = countryData.json.population.jsonDecode(myCustomDecoder)
    
     //You can convert the JSON String directly to any Codable Swift Type
     let country : Country? = countryData.json.jsonDecode()
    
     //Access an array value with index
     let firstTag : String? = countryData.json.tags[0]
```


 
 
