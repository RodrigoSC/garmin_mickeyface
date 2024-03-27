import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class garmin_mickeyView extends WatchUi.WatchFace {
    var counter = 0;
    var screenWidth = 0;
    var screenHeight = 0;
    var hand_hour as Array<BitmapResource> = new Array<BitmapResource>[2];
    var hand_minute as Array<BitmapResource> = new Array<BitmapResource>[2];
    var head as Array<BitmapResource> = new Array<BitmapResource>[2];
    var eyes as Array<BitmapResource> = new Array<BitmapResource>[2];

    function initialize() {
        WatchFace.initialize();
        hand_minute[0] = WatchUi.loadResource($.Rez.Drawables.hand_minute1);
        hand_minute[1] = WatchUi.loadResource($.Rez.Drawables.hand_minute2);
        hand_hour[0] = WatchUi.loadResource($.Rez.Drawables.hand_hour1);
        hand_hour[1] = WatchUi.loadResource($.Rez.Drawables.hand_hour2);
        head[0] = WatchUi.loadResource($.Rez.Drawables.head1);
        head[1] = WatchUi.loadResource($.Rez.Drawables.head2);
        eyes[0] = WatchUi.loadResource($.Rez.Drawables.eyes11);
        eyes[1] = WatchUi.loadResource($.Rez.Drawables.eyes21);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        screenWidth = dc.getWidth();
		screenHeight = dc.getHeight();
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setAntiAlias(true);
        drawHourHand(dc, clockTime.hour, clockTime.min);
        drawHead(dc, clockTime.hour);
        drawMinuteHand(dc, clockTime.min);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    function drawHead(dc as Dc, clock_hour) {
        dc.drawBitmap2(119, 38, head[clock_hour < 6 ?  1 : 0], 
            {:filterMode => Graphics.FILTER_MODE_BILINEAR});
        dc.drawBitmap2(191, 113, eyes[clock_hour < 6 ?  1 : 0], 
            {:filterMode => Graphics.FILTER_MODE_BILINEAR});
    }

    function drawHourHand(dc as Dc, clock_hour, clock_min) {
        var hour = ( ( ( clock_hour % 12 ) * 60 ) + clock_min ); // hour = 2*60.0;
        hour = hour / (12 * 60.0) * Math.PI * 2;
        drawHand(dc, hour, hand_hour[clock_hour < 6 ? 0 : 1]);
    }

    function drawMinuteHand(dc as Dc, clock_min) {
        var min = ( clock_min / 60.0); // min = 40/60.0;
        min = min * Math.PI * 2;
        drawHand(dc, min, hand_minute[clock_min > 30 ? 1 : 0]);
    }

    function drawHand(dc as Dc, angle, hand as BitmapResource) {
        var sin = Math.sin(angle);
        var cos = Math.cos(angle);
        var x = -hand.getWidth() / 2.0;
        var y = -hand.getHeight();

        var transformMatrix = new Graphics.AffineTransform();
        transformMatrix.initialize();
        transformMatrix.translate(x*cos-y*sin, y*cos + x*sin);
        transformMatrix.rotate(angle);
        
        dc.drawBitmap2(screenWidth / 2, screenHeight / 2, hand, {
            :transform => transformMatrix,
            :filterMode => Graphics.FILTER_MODE_BILINEAR
        });
    }
}
