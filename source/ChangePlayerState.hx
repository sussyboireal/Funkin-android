package;

import openfl.display.Preloader.DefaultPreloader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.ui.FlxVirtualPad;

using StringTools;

class ChangePlayerState extends MusicBeatState
{


    var bflist:Array<String> = ['BETA BOYFRIEND', 'BLUE BOYFRIEND', 'MEAN BOYFRIEND'];

	var curSelected:Int = 0;


	var _pad:FlxVirtualPad;

	var BG:FlxSprite;


	var arrowsz_left:FlxSprite;
	var arrowsz_right:FlxSprite;

	var characters:FlxSprite;

	var curselected_text:FlxText;

	var selected:Bool = false;

	var icon:FlxSprite;


	override function create()
	{

        //bg
		BG = new FlxSprite(0, 0).loadGraphic('assets/preload/images/charSelect/BG1.png');

		//characterselect_text
		var characterselect_text:Alphabet = new Alphabet(0, 0, "character select", true, false);
		characterselect_text.screenCenter();
		characterselect_text.y = 50;


		//curselected_text
		curselected_text = new FlxText(0, 10, bflist[0], 24);
		curselected_text.alpha = 0.5;
		curselected_text.x = (FlxG.width) - (curselected_text.width) - 25;



		// arrowsz
		arrowsz_left = new FlxSprite(0, 0).loadGraphic('assets/preload/images/charSelect/arrowsz_left.png');

		arrowsz_right = new FlxSprite(arrowsz_left.width, 0).loadGraphic('assets/preload/images/charSelect/arrowsz_right.png');



		// characters
		characters = new FlxSprite(0, 0);

		characters.frames = FlxAtlasFrames.fromSparrow('assets/preload/images/charSelect/selectbf.png', 'assets/preload/images/charSelect/selectbf.xml');
		characters.antialiasing = true;
		
		characters.animation.addByPrefix('bluebf', 'bluebf instance', 24);
		characters.animation.addByPrefix('meanbf', 'meanbf instance', 24);
		characters.animation.addByPrefix('pissbf', 'pissbf instance', 24);

		characters.animation.addByPrefix('bluebfselect', 'bluebfselect instance', 24);
		characters.animation.addByPrefix('meanbfselect', 'meanbfselect instance', 24);
		characters.animation.addByPrefix('pissbfselect', 'pissbfselect instance', 24);

		
		characters.updateHitbox();
		
		characters.setGraphicSize(Std.int(275));
		
		characters.x = (FlxG.width / 2) - (characters.width / 2);
		characters.y = (FlxG.height / 2) - (characters.height / 2);






		_pad = new FlxVirtualPad(NONE, A_B);
    	_pad.alpha = 0.75;


		icon = new FlxSprite(0, 0).loadGraphic('assets/preload/images/charSelect/frame1.png');


		icon.screenCenter();

		icon.y = FlxG.height - 200;

		//trace(BG.height);


        add(BG);

		add(arrowsz_left);
		add(arrowsz_right);

		add(curselected_text);
        add(characterselect_text);
		add(characters);


		add(icon);
		this.add(_pad);

		changeSelection(0);

		super.create();
	}



	override function update(elapsed:Float)
	{
		if (_pad.buttonB.justPressed || FlxG.android.justReleased.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT || _pad.buttonA.justPressed){
			switch curSelected{
				case 0:
					characters.animation.play('pissbfselect');
				case 1:
					characters.animation.play('bluebfselect');
				case 2:
					characters.animation.play('meanbfselect');
				default:
					characters.animation.play('pissbfselect');

			}
			
			
			selected = true;
			PlayState.bfsel = curSelected;
			
			LoadingState.loadAndSwitchState(new PlayState());
		}


		for (touch in FlxG.touches.list){
			if (touch.overlaps(arrowsz_right) && touch.justReleased && !selected){
				changeSelection(1);
			}
	
			if (touch.overlaps(arrowsz_left) && touch.justReleased && !selected){
				changeSelection(-1);
			}
		}

		if (controls.BACK || _pad.buttonB.justReleased)
			{
				FlxG.switchState(new MainMenuState());
			}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
		{
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = bflist.length - 1;
			if (curSelected >= bflist.length)
				curSelected = 0;
			trace(curSelected);
	
			curselected_text.text = bflist[curSelected];

			icon.loadGraphic('assets/preload/images/charSelect/frame' + (curSelected + 1) + '.png');


			switch curSelected{
				case 0:
					characters.animation.play('pissbf');
					BG.loadGraphic('assets/preload/images/charSelect/BG1.png');
				case 1:
					characters.animation.play('bluebf');
					BG.loadGraphic('assets/preload/images/charSelect/BG2.png');
				case 2:
					characters.animation.play('meanbf');
					BG.loadGraphic('assets/preload/images/charSelect/BG3.png');
				default:
					characters.animation.play('pissbf');
					BG.loadGraphic('assets/preload/images/charSelect/BG1.png');

			}

	
		}
}
