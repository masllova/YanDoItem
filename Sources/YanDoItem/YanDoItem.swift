import Foundation

public struct ToDoItem {
    public let id: String
    public let text: String
    public let importance: Importance
    public let deadline: Date?
    public let isCompleted: Bool
    public let createdDate: Date
    public let dateОfСhange: Date?
     public init(
           id: String = UUID().uuidString,
           text: String,
           importance: Importance,
           deadline: Date?,
           isCompleted: Bool,
           createdDate: Date,
           dateОfСhange: Date?
       ) {
           self.id = id
           self.text = text
           self.importance = importance
           self.deadline = deadline
           self.isCompleted = isCompleted
           self.createdDate = createdDate
           self.dateОfСhange = dateОfСhange
       }
         // for json format
       public enum Keys {
             static let id = "id"
             static let text = "text"
             static let importance = "importance"
             static let deadline = "deadline"
             static let isCompleted = "is_completed"
             static let createdDate = "created_date"
             static let dateOfChange = "date_of_change"
         }
}

public enum Importance: String {
        case low
        case basic
        case important
}

public extension ToDoItem {
    // json format
   public static func parseJSON(json: Any) -> ToDoItem? {
          guard let jsonData = json as? [String: Any] else {
              print("json data not found")
              return nil
          }
          guard let id = jsonData[Keys.id] as? String,
                let text = jsonData[Keys.text] as? String,
                let createdDate = (jsonData[Keys.createdDate] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
          else {return nil}
       let importance = (jsonData[Keys.importance] as? String).flatMap(Importance.init(rawValue:)) ?? .basic
          let deadline = (jsonData[Keys.deadline] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
          let isCompleted = (jsonData[Keys.isCompleted] as? Bool) ?? false
          let dateОfСhange = (jsonData[Keys.dateOfChange] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
          return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, createdDate: createdDate, dateОfСhange: dateОfСhange)
      }
     public var json: Any {
          var jsn: [String: Any] = [:]
          jsn[Keys.id] = id
          jsn[Keys.text] = text
         if importance != .basic {jsn[Keys.importance] = importance.rawValue}
          if let deadline = deadline {jsn[Keys.deadline] = Int(deadline.timeIntervalSince1970)}
          jsn[Keys.isCompleted] = isCompleted
          jsn[Keys.createdDate] = Int(createdDate.timeIntervalSince1970)
          if let dateОfСhange = dateОfСhange {jsn[Keys.dateOfChange] = Int(dateОfСhange.timeIntervalSince1970)}
          return jsn
      }
      // CSV format
     public static func parseCSV(_ csvString: String) -> ToDoItem? {
          let components = csvString.components(separatedBy: ";")
          guard components.count == 7 else {
              print("csv data not correct")
              return nil
          }
          let id = components[0]
          let text = components[1]
         let importance = Importance(rawValue: components[2]) ?? .basic
          let deadline = DateFormatter.csvDateFormatter.date(from: components[3])
          let isCompleted = Bool(components[4]) ?? false
          let createdDate = DateFormatter.csvDateFormatter.date(from: components[5]) ?? Date()
          let dateОfСhange = DateFormatter.csvDateFormatter.date(from: components[6])
          return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, createdDate: createdDate, dateОfСhange: dateОfСhange)
      }
     public var csv: String {
          var csvString = "\(id);\(text);"
         if importance != .basic {
              csvString += "\(importance.rawValue);"
          } else {
              csvString += ";"
          }
          if let deadline = deadline {
              csvString += "\(DateFormatter.csvDateFormatter.string(from: deadline));"
          } else {
              csvString += ";"
          }
          csvString += "\(isCompleted);\(DateFormatter.csvDateFormatter.string(from: createdDate));"
          if let dateОfСhange = dateОfСhange {csvString += "\(DateFormatter.csvDateFormatter.string(from: dateОfСhange));"}
          return csvString
      }
    
}

public extension DateFormatter {
   static let csvDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
       return formatter
   }()
}
