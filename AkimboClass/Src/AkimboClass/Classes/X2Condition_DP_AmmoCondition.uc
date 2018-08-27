class X2Condition_DP_AmmoCondition extends X2Condition;	//this condition allows to perform various ammo checks for the target's primary weapon

var int iAmmo;
var bool ExactMatch;
var bool WantsReload;
var bool NeedsReload;
var bool ForSpinningReload;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;
	local XComGameState_Item PrimaryWeapon;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	//UnitState = XComGameState_Unit(kTarget);
	PrimaryWeapon = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);

	//this is for Spinning Reload Active - I want that ability to be available even at full ammo if the soldier doesn't have Quicksilver
	if (ForSpinningReload)
	{
		if (!UnitState.HasSoldierAbility('DP_Quicksilver')) return 'AA_Success';	//if the soldier doesn't have Quicksilver, we make Spinning Reload available regardless of ammo
		else 
		{
			if (PrimaryWeapon.Ammo < PrimaryWeapon.GetClipSize()) return 'AA_Success';	//if soldier does have Quicksilver, we make ability available only if weapon wants a reload
			else return 'AA_Whatever';
		}
	}


	if (WantsReload && (PrimaryWeapon.Ammo < PrimaryWeapon.GetClipSize())) return 'AA_Success';

	if (NeedsReload && (PrimaryWeapon.Ammo == 0)) return 'AA_Success';

	if (ExactMatch && (PrimaryWeapon.Ammo == iAmmo)) return 'AA_Success';

	return 'AA_Whatever';
}

defaultproperties
{
	iAmmo = 0
	ExactMatch = true
	WantsReload = false
	NeedsReload = false
	ForSpinningReload = false
}