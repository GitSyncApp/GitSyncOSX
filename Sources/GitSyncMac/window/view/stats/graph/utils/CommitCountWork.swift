import Foundation
@testable import Utils
@testable import Element

typealias CommitCountWork = (localPath:String,since:String,until:String,commitCount:Int)

class CommitCountWorkUtils {
    /**
     *
     */
    static func commitCountWork(_ repoItem:RepoItem,_ from:Date, _ until:Date, _ timeType:TimeType)->[CommitCountWork]{
        var numOfTimeUnits:Int
        var offsetDateMethod:Utils.OffsetDateMethod
        switch timeType{
            case .year:
                numOfTimeUnits = from.numOfYears(until)
                offsetDateMethod = DateModifier.offsetByYears
            case .month:
                print("range from 3 to 8")
                numOfTimeUnits = from.numOfMonths(until)
                offsetDateMethod = DateModifier.offsetByMonths
            case .day:
                numOfTimeUnits = from.numOfDays(until)
                offsetDateMethod = DateModifier.offsetByDays
        }
        let commitCountWorks = Utils.commitCountWork(repoItem, from, numOfTimeUnits, offsetDateMethod)
        return commitCountWorks
        
    }
}
private class Utils{
    typealias OffsetDateMethod = (_ date:Date,_ offset:Int)->Date/*Method signature*/
    static func commitCountWork(_ repoItem:RepoItem, _ from:Date, _ numOfTimeUnits:Int, _ offsetBy:OffsetDateMethod)->[CommitCountWork]{
        var commitCountWorks:[CommitCountWork] = []
        for i in (0...numOfTimeUnits){//7 days
            let sinceDate:Date = from.offsetByDays(i)
            let sinceGitDate:String = GitDateUtils.gitTime(sinceDate)
            let untilDate:Date = from.offsetByDays(i+1)
            let untilGitDate:String = GitDateUtils.gitTime(untilDate)
            let comitCountWork:CommitCountWork = (repoItem.localPath,sinceGitDate,untilGitDate,0)
            commitCountWorks.append(comitCountWork)
        }
        return commitCountWorks
    }
}
