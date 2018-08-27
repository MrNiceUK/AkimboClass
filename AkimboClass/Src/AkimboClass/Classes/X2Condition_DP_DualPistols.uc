class X2Condition_DP_DualPistols extends X2Condition config(Akimbo); //this condition checks whether the soldier has dual pistols equipped. This is mostly necessary for Musashi's RPG Overhaul.

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	if (HasDualPistolEquipped(UnitState)) return 'AA_Success';

	return 'AA_Whatever';
}

static function bool IsPrimaryPistolWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
/*
	`Log("IRIDAR =========================",, 'AkimboClass');
	`Log("IRIDAR Checking primary weapon",, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate != none: " @ WeaponTemplate != none,, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate.StowedLocation == eSlot_None: " @ WeaponTemplate.StowedLocation == eSlot_None,, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate.WeaponCat: " @ WeaponTemplate.WeaponCat,, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon: " @ WeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon,, 'AkimboClass');
	`Log("IRIDAR default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE: " @ default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE,, 'AkimboClass');
	*/
	return WeaponTemplate != none &&
		WeaponTemplate.StowedLocation == eSlot_None &&
		WeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon &&
		WeaponTemplate.WeaponCat == 'pistol';
}

static function bool IsSecondaryPistolWeaponTemplate(X2WeaponTemplate WeaponTemplate)
{
/*
	`Log("IRIDAR =========================",, 'AkimboClass');
	`Log("IRIDAR Checking secondary weapon",, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate != none: " @ WeaponTemplate != none,, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate.StowedLocation == eSlot_None: " @ WeaponTemplate.StowedLocation == eSlot_None,, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate.WeaponCat: " @ WeaponTemplate.WeaponCat,, 'AkimboClass');
	`Log("IRIDAR WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon: " @ WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon,, 'AkimboClass');
	`Log("IRIDAR default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE: " @ default.PistolCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE,, 'AkimboClass');
	*/
	return WeaponTemplate != none &&
		WeaponTemplate.StowedLocation == eSlot_None &&
		WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon &&
		WeaponTemplate.WeaponCat == 'pistol';
}

static function bool HasDualPistolEquipped(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return IsPrimaryPistolWeaponTemplate(X2WeaponTemplate(UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon, CheckGameState).GetMyTemplate())) &&
		IsSecondaryPistolWeaponTemplate(X2WeaponTemplate(UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, CheckGameState).GetMyTemplate()));
}	
