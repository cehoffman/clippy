import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.external.ExternalInterface;

class Clippy {
  // Main
  static function main() {
    var text:String     = flash.Lib.current.loaderInfo.parameters.text;
    var id:String       = flash.Lib.current.loaderInfo.parameters.id;
    var call:String     = flash.Lib.current.loaderInfo.parameters.call;
    var copied:String   = flash.Lib.current.loaderInfo.parameters.copied;
    var copyto:String   = flash.Lib.current.loaderInfo.parameters.copyto;
    var callBack:String = flash.Lib.current.loaderInfo.parameters.callBack;

    if(copied   == null)  copied   = "copied!";
    if(copyto   == null)  copyto   = "copy to clipboard";
    if(callBack == null)  callBack = "function(){}";

    // label
    var label:TextField   = new TextField();
    var format:TextFormat = new TextFormat("Helvetica Neue", 13);

    label.text       = copyto;
    label.setTextFormat(format);
    label.textColor  = 0x333333;
    label.selectable = false;
    label.x          = 17;
    label.y          = -2;
    label.width      = 133;
    label.visible    = true;

    flash.Lib.current.addChild(label);
    flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
    flash.Lib.current.stage.align     = flash.display.StageAlign.TOP_LEFT;

    // button

    var button:SimpleButton = new SimpleButton();
    button.useHandCursor    = true;
    button.upState          = flash.Lib.attach("button_up");
    button.overState        = flash.Lib.attach("button_over");
    button.downState        = flash.Lib.attach("button_down");
    button.hitTestState     = flash.Lib.attach("button_down");

    button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
      if (text != null) {
        flash.system.System.setClipboard(text);
        ExternalInterface.call(callBack, text);
      } else if (id != null) {
        flash.system.System.setClipboard(ExternalInterface.call("function(id) { var elem = document.getElementById(id); if(elem) { return(elem.value || elem.innerHTML) } else { alert('WARN: ' + id + ' Not found '); } }", id));
        ExternalInterface.call(callBack, id);
      } else {
        flash.system.System.setClipboard(ExternalInterface.call(call));
        ExternalInterface.call(callBack, call);
      }

      label.text = copied;
      label.setTextFormat(format);
    });

    button.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
      label.visible = true;
    });

    button.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
      label.visible = true;
      label.text    = copyto;
      label.setTextFormat(format);
    });

    flash.Lib.current.addChild(button);
  }
}
