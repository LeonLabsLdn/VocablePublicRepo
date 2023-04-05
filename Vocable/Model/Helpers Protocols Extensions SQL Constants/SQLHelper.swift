import Foundation

let sqlLocation = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

public let part1DbPath = Database.Part1.path
public let part2DbPath = Database.Part2.path

private enum Database: String {
  case Part1
  case Part2
  var path: String? {
    return sqlLocation?.appendingPathComponent("\(self.rawValue).sqlite").relativePath
  }
}

private func destroyDatabase(db: Database) {
  guard let path = db.path else { return }
  do {
    if FileManager.default.fileExists(atPath: path) {
      try FileManager.default.removeItem(atPath: path)
    }
  } catch {
    print("Could not destroy \(db) Database file.")
  }
}

public func destroyPart1Database() {destroyDatabase(db: .Part1)}

public func destroyPart2Database() {destroyDatabase(db: .Part2)}
