class X2Condition_DP_AmmoCondition extends X2Condition;	//this condition allows to perform various ammo checks for the target's primary weapon

var int iAmmo;
var bool ExactMatch;
var bool WantsReload;
var bool CheckQuicksilver;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;
	local XComGameState_Item PrimaryWeapon;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	PrimaryWeapon = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);

	if(CheckQuicksilver && !UnitState.HasSoldierAbility('DP_Quicksilver')) return 'AA_NoQuicksilver';

	if (ExactMatch && PrimaryWeapon.Ammo == iAmmo) return 'AA_Success';
	if (WantsReload && PrimaryWeapon.Ammo < PrimaryWeapon.GetClipSize() || !CheckQuicksilver) return 'AA_Success';

	return 'AA_Whatever';
}

defaultproperties
{
	iAmmo = 0
	ExactMatch = true
	WantsReload = false
	CheckQuicksilver = false
}