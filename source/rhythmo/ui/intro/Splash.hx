package rhythmo.ui.intro;

import rhythmo.Paths;
import rhythmo.ui.BaseState;
import rhythmo.ui.menu.MainMenu;
import flixel.util.FlxGradient;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Splash extends BaseState
{
    var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFFAA00AA);
	var timer:Float = 0;

    override public function create():Void
    {
        gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x003500ff, 0x55a800ff, 0xAAe200ff], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		gradientBar.scale.y = 0;
		add(gradientBar);
		FlxTween.tween(gradientBar, {'scale.y': 1.3}, 4, {ease: FlxEase.quadInOut});

        var text:FlxText = new FlxText(0, 0, FlxG.width, 'Created by Joalor64\nMade with HaxeFlixel');
		text.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER);
		text.screenCenter();
		add(text);

        new FlxTimer().start(3, (tmr:FlxTimer) -> transitionState(new MainMenu()));

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        var timer:Float = 0;

        timer++;

		gradientBar.scale.y += Math.sin(timer / 10) * 0.001;
		gradientBar.updateHitbox();
		gradientBar.y = FlxG.height - gradientBar.height;

        super.update(elapsed);
    }
}