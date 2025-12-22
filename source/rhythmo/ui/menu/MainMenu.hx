package rhythmo.ui.menu;

import rhythmo.Paths;
import rhythmo.input.Input;
import rhythmo.ui.BaseState;
import rhythmo.play.Gameplay;
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
		#if hxdiscord_rpc
		rhythmo.api.DiscordClient.changePresence('Main Menu', null);
		#end

		var bg:FlxSprite = new GameSprite().loadGraphic(Paths.image('menu/backgrounds/title_bg'));
		add(bg);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		add(grid);

		var logo:FlxSprite = new GameSprite(0, 70).loadGraphic(Paths.image('menu/logo'));
		logo.scale.set(0.65, 0.65);
		logo.screenCenter(X);
		add(logo);

		selectionGroup = new FlxTypedGroup<FlxSprite>();
		add(selectionGroup);

		var numItems:Int = nameArr.length;
		var itemSize:Int = 120;
		var spacing:Int = 150;
		var totalWidth:Int = (numItems - 1) * spacing + itemSize;
		var startX:Float = (FlxG.width - totalWidth) / 2;
		var logoMenuPadding:Int = 0;
		var menuY:Float = logo.y + logo.height + logoMenuPadding;

		for (i in 0...numItems)
		{
			var menuItem:FlxSprite = new FlxSprite(startX + i * spacing, menuY).makeGraphic(itemSize, itemSize, colArr[i]);
			menuItem.ID = i;
			selectionGroup.add(menuItem);
		}

		optionTxt = new FlxText(0, menuY + itemSize + 10, FlxG.width, '');
		optionTxt.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionTxt.screenCenter(X);
		add(optionTxt);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (!lockInputs)
		{
			if (Input.justPressed('ui_left'))
				selectedIndex = (selectedIndex - 1 + selectionGroup.length) % selectionGroup.length;
			else if (Input.justPressed('ui_right'))
				selectedIndex = (selectedIndex + 1) % selectionGroup.length;

			/*if (Input.justPressed('accept'))
			{
				lockInputs = true;
				switch (nameArr[selectedIndex])
				{
					case 'Play':
						transitionState(new Gameplay());
					case 'Mods':
						trace('unfinished');
					case 'Achievements':
						trace('unfinished');
					case 'Credits':
						trace('unfinished');
					case 'Options':
						trace('unfinished');
					case 'Exit':
						Sys.exit(0);
				}
			}*/
		}

		for (i in 0...selectionGroup.length)
		{
			var item:FlxSprite = selectionGroup.members[i];
			if (i == selectedIndex)
			{
				item.scale.set(1.2, 1.2);
				optionTxt.text = nameArr[i];
			}
			else
				item.scale.set(1, 1);
		}

		super.update(elapsed);
	}
}
