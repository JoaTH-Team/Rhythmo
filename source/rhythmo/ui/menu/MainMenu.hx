package rhythmo.ui.menu;

import rhythmo.Paths;
import rhythmo.ui.BaseState;
import rhythmo.graphics.GameSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

class MainMenu extends BaseState
{
    var lockInputs:Bool = false;

    var selectionGroup:FlxTypedGroup<FlxSprite>;
    var selectedIndex:Int = 0;

    override public function create():Void
    {
        var bg:FlxSprite = new GameSprite().loadGraphic(Paths.image('menu/backgrounds/title_bg'));
        add(bg);

        var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		add(grid);

        var logo:FlxSprite = new GameSprite(0, 150).loadGraphic(Paths.image('menu/logo'));
		logo.scale.set(0.6, 0.6);
		logo.screenCenter(X);
		add(logo);
    }
}