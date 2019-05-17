//
//  DZMReadModel+Mark.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/19.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

extension DZMReadModel {

    /// 添加书签,默认使用当前阅读记录!
    func insetMark(recordModel:DZMReadRecordModel? = nil) {
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let markModel = DZMReadMarkModel()
        
        markModel.bookID = recordModel.bookID
        
        markModel.chapterID = recordModel.chapterModel.id
        
        if recordModel.pageModel.isHomePage {
            
            markModel.name = "(无章节名)"
            
            markModel.content = bookName
            
        }else{
            
            markModel.name = recordModel.chapterModel.name
            
            markModel.content = recordModel.contentString.removeSEHeadAndTail.removeEnterAll
        }
        
        markModel.time = NSNumber(value: Timer1970())
        
        markModel.location = recordModel.locationFirst
        
        if markModels.isEmpty {
            
            markModels.append(markModel)
            
        }else{
            
            markModels.insert(markModel, at: 0)
        }
        
        save()
    }
    
    /// 移除当前书签
    func removeMark(index:NSInteger) ->Bool {
        
        markModels.remove(at: index)
        
        save()
        
        return true
    }
    
    /// 移除当前书签
    func removeMark(recordModel:DZMReadRecordModel? = nil) ->Bool {
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let markModel = isExistMark(recordModel: recordModel)
        
        if markModel != nil {
            
            let index = markModels.index(of: markModel!)!
            
            return removeMark(index: index)
        }
        
        return false
    }
    
    /// 是否存在书签
    func isExistMark(recordModel:DZMReadRecordModel? = nil) ->DZMReadMarkModel? {
        
        if markModels.isEmpty { return nil }
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let locationFirst = recordModel.locationFirst!
        
        let locationLast = recordModel.locationLast!
        
        for markModel in markModels {
            
            if markModel.chapterID == recordModel.chapterModel.id {
                
                if (markModel.location.intValue >= locationFirst.intValue) && (markModel.location.intValue < locationLast.intValue) {
                    
                    return markModel
                }
            }
        }
        
        return nil
    }
}
