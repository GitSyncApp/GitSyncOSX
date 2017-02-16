import Foundation
@testable import Utils
@testable import Element

class FastList4:Element,IList {
    var itemHeight:CGFloat/*The list item height, each item must have the same height*/
    var dataProvider:DataProvider/*data storage*/
    var lableContainer:Container?/*holds the list items*/
    var pool:[FastListItem] = []
    
    init(_ width:CGFloat, _ height:CGFloat, _ itemHeight:CGFloat = NaN,_ dataProvider:DataProvider? = nil, _ parent:IElement?, _ id:String? = nil){
        self.itemHeight = itemHeight
        self.dataProvider = dataProvider ?? DataProvider()/*<--if it's nil then a DB is created*/
        super.init(width, height, parent, id)
        self.dataProvider.event = self.onEvent/*Add event handler for the dataProvider*/
        
    }
    override func resolveSkin() {
        super.resolveSkin()
    
        lableContainer = addSubView(Container(width,height,self,"lable"))
        
        /*let numOfItemsThatCanFitHeight:Int = numOfItemsThatCanFit
         _ = numOfItemsThatCanFitHeight*/
        
        /*calc visibleItems based on lableContainer.y and height*/
        let visibleItemRangeWithinView:Range<Int> = visibleItemRange
        _ = visibleItemRangeWithinView
        
        let range:Range<Int> = visibleItemRange.start..<Swift.min(visibleItemRange.end,dp.count)
        //Swift.print("range: " + "\(range)")
        renderItems(range)
    }
    /**
     * PARAM: progress (0-1)
     */
    func setProgress(_ progress:CGFloat){
        ListModifier.scrollTo(self, progress)/*moves the labelContainer up and down*/
        let range:Range<Int> = visibleItemRange.start..<Swift.min(visibleItemRange.end,dp.count)
        //Swift.print("range: " + "\(range)")
        /**/
        if(currentVisibleItemRange != range){/*Optimization: only set if it's not the same as prev range*/
            renderItems(range)
        }
    }
    /**
     * TODO: You can optimize the range stuff later when all cases work
     */
    func renderItems(_ range:Range<Int>){
        //Swift.print("new: " + "\(range)")
        var inActive:[FastListItem] = []
        /**/
        let old = currentVisibleItemRange
        //Swift.print("old: " + "\(old)")
        let new = range
        let firstOldIdx:Int = old.start
        //Swift.print("firstOldIdx: " + "\(firstOldIdx)")
        /*figure out which items to remove from pool*/
        let diff = RangeParser.difference(new, old)//may return 1 or 2 ranges
        //Swift.print("diff: " + "\(diff)")
        
        if(diff.1 != nil){
            let start = diff.1!.start - firstOldIdx
            inActive += pool.splice2(start, diff.1!.length)
        }
        if(diff.0 != nil){
            let start = diff.0!.start - firstOldIdx
            inActive += pool.splice2(start, diff.0!.length)
        }
        //Swift.print("remove: \(inActive.count)")
        /*figure out which items to add to pool*/
        let diff2 = RangeParser.difference(old,new)
        //Swift.print("diff2: " + "\(diff2)")
        
       
        if(diff2.1 != nil){
            let startIdx = diff2.1!.start
            let endIdx = diff2.1!.end
            var items:[FastListItem] = []
            for i in (startIdx..<endIdx){
                let item:Element = inActive.count > 0 ? inActive.popLast()!.item : createItem(i)
                let fastListItem:FastListItem = (item:item,idx:i)
                reUse(fastListItem)//applies data and position
                items.append(fastListItem)
            }
            if(items.count > 0){
                var idx:Int = items.first!.idx - firstOldIdx//index in pool
                idx = idx.clip(0, pool.count)
                _ = ArrayModifier.mergeInPlaceAt(&pool, &items, idx)
            }
        }
        //Swift.print("pool.count: " + "\(pool.count)")
        
        if(diff2.0 != nil){
            let startIdx = diff2.0!.start
            let endIdx = diff2.0!.end
            var items:[FastListItem] = []
            for i in (startIdx..<endIdx){
                let item:Element = inActive.count > 0 ? inActive.popLast()!.item : createItem(i)
                let fastListItem:FastListItem = (item:item,idx:i)
                reUse(fastListItem)//applies data and position
                items.append(fastListItem)
            }
            if(items.count > 0){
                var idx:Int = items.first!.idx - firstOldIdx//index in pool
                idx = idx.clip(0, pool.count)
                _ = ArrayModifier.mergeInPlaceAt(&pool, &items, idx)
            }
        }
        
        //Swift.print("add: \((diff2.0 != nil ? diff2.0!.length : 0) + (diff2.1 != nil ? diff2.1!.length : 0))")
        //Swift.print("pool.count: " + "\(pool.count)")
        //clear inActive array, if any are left, can happen after resize etc
        //Swift.print("inActive.count: " + "\(inActive.count)")
        
        inActive.forEach{$0.item.removeFromSuperview()}
        inActive.removeAll()
    }
    /**
     *
     */
    func reUse(_ listItem:FastListItem){/*override this to use custom ItemList items*/
        //Swift.print("reUse: " + "\(listItem.idx)")
        let item:SelectTextButton = listItem.item as! SelectTextButton
        let idx:Int = listItem.idx/*the index of the data in dataProvider*/
        let dpItem = dataProvider.items[idx]
        let title:String = dpItem["title"]!
        item.setTextValue(idx.string + " " + title)
        item.y = listItem.idx * itemHeight/*position the item*/
    }
    /**
     *
     */
    func createItem(_ index:Int) -> Element{
        let item:SelectTextButton = SelectTextButton(getWidth(), itemHeight ,"", false, lableContainer)
        lableContainer!.addSubview(item)
        return item
    }
    /**
     * TODO: you need to update the float of the lables after an update
     */
    func onDataProviderEvent(_ event:DataProviderEvent){
        if(event.type == DataProviderEvent.add){/*This is called when a new item is added to the DataProvider instance*/
            let endIdx:Int = event.startIndex + event.items.count
            //updateRange(event.startIndex..<endIdx)
        }else if(event.type == DataProviderEvent.remove){
            let endIdx:Int = event.startIndex + event.items.count
            //updateRange(event.startIndex..<endIdx)
            
        }
    }
    override func onEvent(_ event:Event) {
        if(event is DataProviderEvent){onDataProviderEvent(event as! DataProviderEvent)}
        super.onEvent(event)// we stop propegation by not forwarding events to super. The ListEvents go directly to super so they wont be stopped.
    }
    override func getClassType() -> String {return "\(List.self)"}
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}

extension FastList4{
    /**
     * Returns the range to render (based on items in DP and how the lableContainer is positioned)
     */
    var visibleItemRange:Range<Int>{
        let firstVisibleItemThatCrossTopOfView = firstVisibleItem
        let lastVisibleItemThatIsWithinBottomOfView = lastVisibleItem
        let visibleItemRange:Range<Int> = firstVisibleItemThatCrossTopOfView..<lastVisibleItemThatIsWithinBottomOfView
        return visibleItemRange
    }
    /**
     * Returns the current visible item range in List
     */
    var currentVisibleItemRange:Range<Int>{
        let firstIdx:Int = pool.count > 0 ? pool.first!.idx : 0
        let lastIdx:Int = pool.count > 0 ? pool.first!.idx + pool.count : 0
        //Swift.print("lastIdx: " + "\(lastIdx)")
        let currentVisibleItemRange:Range<Int> = firstIdx..<lastIdx
        return currentVisibleItemRange
    }
}
