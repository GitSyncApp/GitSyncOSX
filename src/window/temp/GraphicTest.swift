import Cocoa

class GraphicsTest:Graphic{
    var x:Int
    var y:Int
    var width:Int
    var height:Int
    var color:NSColor
    var thePath:CGMutablePath
    init(_ x:Int = 0, _ y:Int = 0,_ width:Int = 100, _ height:Int = 100, _ color:NSColor = NSColor.blueColor()) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.color = color
        self.thePath = CGPathParser.rect(CGFloat(200/*width/2*/),CGFloat(200/*height/2*/))//Shapes
        super.init(frame:NSRect(x: x,y: y,width: width,height: height))
        //self.wantsLayer = true//this avoids calling drawLayer() and enables drawingRect()
        //needsDisplay = true;
        //Swift.print("graphics: " + String(graphics.context))
    }
    /*
    override func displayLayer(layer: CALayer) {
    //try
    Swift.print("displayLayer")
    }
    */
    /*
    * Required by super class
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     *
     */
    override func drawRect(dirtyRect: NSRect) {
        Swift.print("GraphicsTest.drawRect: " )
        
        CGPathModifier.translate(&thePath,CGFloat(x),CGFloat(y))//Transformations
        //graphics.line(12)//Stylize the line
        
        graphics.fill(color)//Stylize the fill
        graphics.draw(thePath)//draw everything
        
        //super.drawRect(dirtyRect)
    }
}