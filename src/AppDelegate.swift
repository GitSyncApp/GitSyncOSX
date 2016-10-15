import Cocoa
/**
 * This is the main class for the application
 * TODO: An idea is to hide the interface when the mouse is not over the app (anim in and out)
 */
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    weak var window: NSWindow!
    var repoFilePath:String = "~/Desktop/repo.xml"
    var win:NSWindow?/*<--The window must be a class variable, local variables doesn't work*/
    var fileWatcher:FileWatcher?
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        
        Swift.print("GitSync - A really simple Git app")
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/gitsync.css",true)//<--toggle this bool for live refresh
        
        win = MainWin(MainView.w,MainView.h)
        
        let url:String = "~/Desktop/ElCapitan/gitsync.css"
        fileWatcher = FileWatcher([url.tildePath])
        fileWatcher!.event = { event in
            //Swift.print(self)
            Swift.print(event.description)
            if(event.fileChange && event.path == url.tildePath) {
                Swift.print("update to the file happened")
                StyleManager.addStylesByURL(url,true)
                let view:NSView = self.win!.contentView!
                ElementModifier.refreshSkin(view as! IElement)
                ElementModifier.floatChildren(view)
            }
        }
        fileWatcher!.start()
        
        
        //Continue here:
            //Add the detail view from legacy
        
        //later
            //use the iphone 6 size ratio by default
            //Use the san fran font
            //tranclucency layer under the topbar and bottombar? try it! (or just all tranclucenct)
            //backButton next to the close,min,max buttons. (When needed)
        
        
        
    }
    func applicationWillTerminate(aNotification: NSNotification) {
        print("Good-bye")
    }
}
