package rhythmo.ui.menu;

import rhythmo.Paths;
import rhythmo.input.Input;
import rhythmo.ui.BaseState;
import rhythmo.graphics.GameSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

class MainMenu extends BaseState
{
    var lockInputs:Bool = false;

    var selectionGroup:FlxTypedGroup<FlxSprite>;
    var selectedIndex:Int = 0;

    // until proper menu assets are made
    var colArr:Array<FlxColor> = [0xFF9900F0, 0xFF4766FF, 0xFF00FF00, 0xFFFFD31A, 0xFFFF8F1F, 0xFFFF2976];
    var nameArr:Array<String> = ['Play', 'Mods', 'Achievements', 'Credits', 'Options', 'Exit'];

    var optionTxt:FlxText;

    override public function create():Void
    {
        var bg:FlxSprite = new GameSprite().loadGraphic(Paths.image('menu/backgrounds/title_bg'));
        add(bg);

        var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		add(grid);

        var logo:FlxSprite = new GameSprite(0, 60).loadGraphic(Paths.image('menu/logo'));
		logo.scale.set(0.6, 0.6);
		logo.screenCenter(X);
		add(logo);

        selectionGroup = new FlxTypedGroup<FlxSprite>();
        add(selectionGroup);

        for (i in 0...5)
        {
            var menuItem:FlxSprite = new FlxSprite(i * 100, 500).makeGraphic(70, 70, colArr[i]);
            menuItem.screenCenter(Y);
            menuItem.ID = i;
            selectionGroup.add(menuItem);
        }

        super.create();
    }
}