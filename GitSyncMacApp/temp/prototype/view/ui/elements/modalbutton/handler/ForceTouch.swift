import Cocoa
@testable import Utils
@testable import Element

extension ModalButton{
    /**
     * ForceTouch handler for modal
     */
    func forceTouchHandler(_ event:ForceTouchEvent)  {
        //let indexOfModal:Int = self.indexOfModal(event.origin)
        //Swift.print("event.type: " + "\(event.type)")
        if event.type == ForceTouchEvent.clickDown{//TODO: use switch
            clickDown()
        }else if event.type == ForceTouchEvent.clickUp {
            clickUp()
        }else if event.type == ForceTouchEvent.deepClickDown{
            deepClickDown()
        }else if event.type == ForceTouchEvent.deepClickUp {
            deepClickUp()
        }
        if event.type == ForceTouchEvent.stageChange {
            stageChange(event)
        }
    }
    private func clickDown(){
        Swift.print("clickDown")
        Swift.print("self.index: " + "\(self.index)")
        modalAnimator.setTargetValue(Modal.click(self.index)).start()
    }
    private func clickUp(){
        Swift.print("clickUp")
        if !ProtoTypeView.shared.modalStayMode {//modal stay
            modalAnimator.setTargetValue(Modal.initial(self.index)).start()//transition Modal from expanded to initial, if it was in expanded
        }
    }
    private func deepClickDown(){
        Swift.print("deepClickDown")
        ProtoTypeView.shared.curModal = self//set cur active modal
        modalAnimator.setTargetValue(Modal.expanded).start()//Swift.print("window.contentView.localPos(): " + "\(window.contentView!.localPos())")
        onMouseDownMouseY  = self.window!.contentView!.localPos().y
        NSEvent.addMonitor(&leftMouseDraggedMonitor,.leftMouseDragged,leftMouseDraggedClosure)
    }
    private func deepClickUp(){
        Swift.print("deepClickUp")
        if ProtoTypeView.shared.modalStayMode {/*modal stay*/
            Swift.print("modal stay")
            ProtoTypeView.shared.curModal?.removeHandler()
            modalAnimator.direct = false
            var rect = Modal.expanded
            rect.origin.y -= 30
            modalAnimator.setTargetValue(rect).start()
        }else{/*modal leave*/
            Swift.print("modal leave")
            modalAnimator.direct = false
            modalAnimator.setTargetValue(Modal.initial(self.index)).start()
            /*promptBtn*/
            ProtoTypeView.shared.promptBtnAnimator.setTargetValue(ProtoTypeView.PromptButton.initial.origin).start() //anim bellow screen
        }
        NSEvent.removeMonitor(&leftMouseDraggedMonitor)
    }
    /**
     * when forcetouch changes state
     */
    private func stageChange(_ event:ForceTouchEvent){
        let stage:Int = event.stage
        //Swift.print("stage: " + "\(stage)")
        if stage == 0 && !ProtoTypeView.shared.modalStayMode{
            self.setAppearance(ProtoTypeView.Colors.Modal.initial(self.index))
        }else if stage == 1 && !ProtoTypeView.shared.modalStayMode && event.prevStage == 0{//only change to red if prev stage was 0
            self.setAppearance(ProtoTypeView.Colors.Modal.click)
            deFocusOtherButtons()
        }else if stage == 2 && !ProtoTypeView.shared.modalStayMode{
            self.setAppearance(ProtoTypeView.Colors.Modal.expanded(self.index))
        }
    }
    /**
     * New
     */
    private func toggleFocusForOtherButtons( _ isFocused:Bool){
        ElementParser.children(ProtoTypeView.shared, ModalButton.self)
            .filter {return $0 !== self}
            .forEach{
                let color:NSColor = {
                    if isFocused {
                        return ProtoTypeView.Colors.Modal.UnFocused.background
                    }else {
                        return ProtoTypeView.Colors.Modal.initial($0.index)
                    }
                }()
                $0.setAppearance(color)
        }
    }
    private func deFocusOtherButtons(){
        ElementParser.children(ProtoTypeView.shared, ModalButton.self)
            .filter {return $0 !== self}
            .forEach{
                $0.setAppearance(ProtoTypeView.Colors.Modal.UnFocused.background)
        }
    }
    
}