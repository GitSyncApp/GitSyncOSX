import Cocoa
@testable import Element
@testable import Utils
/**
 * NOTE: Indentation is the width of the checkBoxButton
 */

//Continue here:
    //the custom setting of style is not good. Seperate style and content ☝️
    //try to think of a way to access styles faster. You have more knowledege now. 👈


class TreeList3:ElasticScrollFastList3{//ElasticSlideScrollFastList3
    var treeDP:TreeDP2 {return dp as! TreeDP2}
    override func reUse(_ listItem:FastListItem) {
        let idx3d:[Int] = treeDP.hashList[listItem.idx]
        //listItem.item.id = idx3d.count.string/*the indentation level (from 1 and up)*/
        
        if let treeListItem = listItem.item as? TreeList3Item,let checkBox = treeListItem.checkBox, let isOpenStr = TreeDP2Parser.getProp(treeDP, idx3d, "isOpen"){/*Is checkable and open*/
            let isChecked = isOpenStr == "true"
            //if(checkBox.getChecked() != isChecked){//only alter state if that state is the opposite of current state
                disableAnim{
                    /*checkBox.isChecked = isChecked
                     var checkBoxStyle:IStyle = checkBox.skin!.style!
                     StyleModifier.overrideStyleProperty(&checkBoxStyle, StyleProperty("transform",isChecked ? 0 : 90,1))//you could also store checked style interim. The best solution would be to add some better caching of syles recently accessd
                     checkBox.skin?.setStyle(checkBoxStyle)*/
                    checkBox.setChecked(isChecked)
                }/*Sets correct open/close icon*/
            //}
        }
        disableAnim{//sets correct indentation
            //listItem.item.setSkinState(listItem.item.getSkinState())
            //get to checkbox and text
            //get checkbox width 
            if let treeListItem = listItem.item as? TreeList3Item,
                let checkBoxWidth:CGFloat = treeListItem.checkBox?.getWidth() {
                Swift.print("🍊 \(listItem.idx)")
                
                let indentationMultiplier:Int = idx3d.count - 1
                let checkBoxX:CGFloat = checkBoxWidth * indentationMultiplier
                let textX:CGFloat = checkBoxX + checkBoxWidth
                treeListItem.checkBox?.point.x = checkBoxX
                treeListItem.text?.point.x = textX
            }
        }
        //let hasChildren:Bool = TreeDP2Asserter.hasChildren(treeDP, idx3d)//Does item have children?
        ////hides checkBox if item doesnt have children
        //(listItem.item as! TreeList3Item).checkBox!.isHidden = !hasChildren
        super.reUse(listItem)/*sets text and position and select state*/
    }
    override func createItem(_ index:Int) -> Element {
        return Utils.createTreeListItem(itemSize,contentContainer!)
    }
    override func onEvent(_ event:Event) {
        if(event.type == CheckEvent.check /*&& event.immediate === itemContainer*/){onItemCheck(event as! CheckEvent)}
        else if(event.type == SelectEvent.select /*&& event.immediate === itemContainer*/){onItemSelect(event as! SelectEvent)}
        super.onEvent(event)
    }
    override func getClassType() -> String {
        return "\(TreeList3.self)"
    }
}
extension TreeList3{
    /**
     * NOTE: This method gets all CheckEvent's from all decending ICheckable instances
     */
    func onItemCheck(_ event:CheckEvent) {
        Swift.print("onItemCheck")
        Swift.print("event.origin: " + "\(event.origin)")
        let idx2d:Int = FastList3Parser.idx(self, (event.origin as! NSView).superview!)!
        let isOpen:Bool = TreeDP2Parser.getProp(treeDP, idx2d, "isOpen") == "true"
        if(isOpen){
            Swift.print("close 🚫 idx2d: \(idx2d)")
            TreeDP2Modifier.close(treeDP, idx2d)
        }else{
            Swift.print("open ✅ idx2d: \(idx2d)")
            TreeDP2Modifier.open(treeDP, idx2d)
        }
        moverGroup!.yMover.contentFrame = (0,contentSize.height)/*updates mover group to avoid jumpiness*/
        moverGroup!.xMover.contentFrame = (0,contentSize.width)
        /*if let element = event.origin as? IElement{
         Swift.print("Stack: " + "\(ElementParser.stackString(element))")
         //Swift.print("element.id: " + "\(element.id)")
         }*/
        //onEvent(TreeListEvent(TreeListEvent.change,self))
    }
    func onItemSelect(_ event:SelectEvent){
        Swift.print("onItemSelect")
    }
}
private class Utils{
    /*create TreeItem*/
    static func createTreeListItem(_ itemSize:CGSize, _ parent:Element) -> TreeList3Item{
        Swift.print("itemSize: " + "\(itemSize)")
        let item:TreeList3Item = TreeList3Item(itemSize.width, itemSize.height ,"", false, false, parent)
        parent.addSubview(item)
        return item
    }
}
