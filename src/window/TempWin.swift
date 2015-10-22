import Foundation
import Cocoa

class TempWin:NSWindow, NSApplicationDelegate,NSTableViewDelegate{
    let titles:[String] = ["Add","Remove","Info","View","test"]
    static var width = 800//Static variable, reachable on a class level
    static var height = 600
    static var sizeRect:NSRect = NSRect(x: 0, y: 0, width: TempWin.width, height: TempWin.height)//NSMakeRect(0, 0, TempWin.width, TempWin.height)
    var view:FlippedView = FlippedView(frame: TempWin.sizeRect)
    
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: TempWin.sizeRect, styleMask: NSTitledWindowMask|NSResizableWindowMask|NSMiniaturizableWindowMask|NSClosableWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        self.makeKeyAndOrderFront(nil)//moves the window to the front
        self.makeMainWindow()
        
        //let controller = NSWindowController(window: newWindow)
        //controller.showWindow(self)
        self.center()
        self.contentView = view
        self.title = "GitSync"
        createContent()
    }
    /*
    * Required by the NSWindow
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    *
    */
    func createContent(){ 
        createButtons()
        //createTextField()
        createTable()
        
    }
    /*
    *
    */
    func createButtons(){
        let topPadding:Int = 24
        let buttonSpacing:Int = 12
        
        var buttons:Array<NSButton> = []
        
        //TODO:  store buttons globaly, and switch in the myaction call
        //TODO: create a view named container with buttons that the tableview then can pin itself to
        //TODO: create debug button so you can test how to get the table row id of the selected row
        
        for title:String in titles{
            let button = Create.textButton(title)
            view.addSubview(button)//Add button to view
            button.target = self//event dispataches to this instance
            button.action = "myAction:"//event dispatches to this method
            buttons.append(button)//add button to button list
        }
        Align.horizontal(buttons,TempWin.width,topPadding,buttonSpacing)//aligns the buttons
    }
    /*
    * NSTableView
    */
    
    func createTable(){
        let tableWidth:Int = 500
        let tablePosX:Int = (TempWin.width/2) - (tableWidth/2)
        let tableContainerRect:NSRect = NSRect(x: tablePosX, y: 80, width: 500,height:300)//view.bounds
        let tableContainer = NSScrollView(frame: tableContainerRect)
        let tableView = TempTableView(frame: tableContainer.frame)//tableContainer.frame.width-100, height: tableContainer.frame.height
        self.makeFirstResponder(tableView)//focus tableView,doesnt work yet
        
        tableView.setDataSource(tableView)//set the datasource
        tableView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable //TODO: try to get height working here to
        tableView.usesAlternatingRowBackgroundColors = true
        
        let columnA = NSTableColumn(identifier: "status")
        columnA.headerCell.title = "Status: "
        tableView.addTableColumn(columnA)
        
        let columnB = NSTableColumn(identifier: "remote-repo")
        columnB.headerCell.title = "Repository: "
        tableView.addTableColumn(columnB)
        
        let columnC = NSTableColumn(identifier: "branch")
        columnC.headerCell.title = "Branch: "
        tableView.addTableColumn(columnC)
        
        let columnD = NSTableColumn(identifier: "active")
        columnD.headerCell.title = "Active: "
        tableView.addTableColumn(columnD)
        
        tableView.setDelegate(self)//listen for delagation events
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        view.addSubview(tableContainer)//add to the view
    }
    /*
    * NSTextField
    */
    func createTextField(){
        let textField = NSTextField(frame: NSRect(x: 0, y: 130, width: 100, height: 20))
        textField.stringValue = "Test"
        view.addSubview(textField)
        //print("Hello world again")
    }
    /*
    * EventHandler for the button
    */
    func myAction(obj:AnyObject!){
        //Swift.print(ClassParser.getClass(obj))
        Swift.print("My class is \((obj as! NSObject).className)")
        if let button = obj as? NSButton{
            switch button.title{
            case titles[0]:
                Swift.print(titles[0])
               
            case titles[1]:
                Swift.print(titles[1])
                
            case titles[2]:
                Swift.print(titles[2])
                
            case titles[3]:
                Swift.print(titles[3])
                
            case titles[4]:
                Swift.print(titles[4])
                //do debug stuff
            default:
                break
            }
        }
    }
}
