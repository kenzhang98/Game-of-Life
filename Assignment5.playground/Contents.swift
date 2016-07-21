let notLeapYearDate = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
let LeapYearDate = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

func isLeap(year:Int) ->  Bool {
    return ((year % 4 == 0) != ((year % 100 == 0) != (year % 400 == 0)))
}

func julianDate(year: Int, month: Int, day: Int) -> Int {
    var dateArr = (1900..<year).map {isLeap($0) ? LeapYearDate : notLeapYearDate}
    dateArr += [(0..<month-1).map {isLeap(year) ? LeapYearDate[$0]: notLeapYearDate[$0]}]
    return dateArr.flatMap {$0}.reduce(day, combine: +)
}

julianDate(1960, month:  9, day: 28)
julianDate(1900, month:  1, day: 1)
julianDate(1900, month: 12, day: 31)
julianDate(1901, month: 1, day: 1)
julianDate(1901, month: 1, day: 1) - julianDate(1900, month: 1, day: 1)
julianDate(2001, month: 1, day: 1) - julianDate(2000, month: 1, day: 1)
isLeap(1960)
isLeap(1900)
isLeap(2000)