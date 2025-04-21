class InspectWeapon_Keybinder
{
	var animations : array< name >;
	
	function Init()
	{
		theInput.RegisterListener(this, 'OnRunInspect', 'InspectSword');
		animations.PushBack('inventory_sword_check1');
		animations.PushBack('inventory_sword_check2');
		animations.PushBack('inventory_sword_check3');
		animations.PushBack('inventory_heavy_melee_check1');
		animations.PushBack('man_work_sword_sharpening_07');
		animations.PushBack('man_work_sword_sharpening_05');
	}

	var anim : name;
	var animRunning : bool;
	var lastValue : int;
	var time : float;
	var num : int;
	
	event OnRunInspect( action : SInputAction ) 
	{
		if(animRunning == false)
		{
			num = RandDifferent(lastValue, animations.Size());
			lastValue = num;
		
			anim = animations[num];
			
			if(anim == 'man_work_sword_sharpening_05')
			{
				time = 6.5;
			}
			else if(anim == 'man_work_sword_sharpening_07')
			{
				time = 5.9735;
			}
			else
			{
				time = 4.0;
			}
			
			GetWitcherPlayer().AddTimer('PlayInspectAnim', 0, false);
			GetWitcherPlayer().AddTimer('PlayInspectAnimCount', time, false);
			animRunning = true;
		}
		else
		{
			//GetWitcherPlayer().DisplayHudMessage("Timer running!");
		}
	}
	
	private function isPlayerHoldingSword() : bool {
		var equippedItemSteel: SItemUniqueId;
		var equippedItemSilver: SItemUniqueId;
		
		// Get the currently equipped steel and silver swords
		GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, equippedItemSteel);
		GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, equippedItemSilver);
		
		// Check if either slot contains an item (i.e., a sword is equipped)
		if (equippedItemSteel != GetInvalidUniqueId() || equippedItemSilver != GetInvalidUniqueId()) {
			
			if(GetWitcherPlayer().IsItemHeld(equippedItemSteel) || GetWitcherPlayer().IsItemHeld(equippedItemSilver))
			{
				return true;
			}
		}
		
		return false;
	}
	
	//Quick control for other kind of custom anims
	function forceanim()
	{
		if(isPlayerHoldingSword() && !thePlayer.GetIsRunning())
		{
			//GetWitcherPlayer().DisplayHudMessage(num + " " + anim);
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( anim, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.7f, 0.7f) );
		}
	}
	
	function stopanim()
	{
		// anims that need to be stopped manually
		if(anim == 'man_work_sword_sharpening_07')
		{
			//GetWitcherPlayer().DisplayHudMessage("Anim stopped");
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'inventory_sword_idle', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.7f, 0.7f) );
		}
	}
}

