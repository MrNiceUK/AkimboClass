class X2Condition_DP_CycleGuns extends X2Condition;	//this condition returns true if it's specific gun's (right or left) turn to shoot

var int NextGunToFire;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;
	local UnitValue NextGun;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	UnitState.GetUnitValue(class'X2Effect_DP_CycleGuns'.default.NextGunValue, NextGun);

	if (NextGun.fValue == NextGunToFire) return 'AA_Success';

	return 'AA_Whatever';
}

defaultproperties
{
	NextGunToFire = 2
}