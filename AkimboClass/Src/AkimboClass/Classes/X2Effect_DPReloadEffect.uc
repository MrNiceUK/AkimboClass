class X2Effect_DPReloadEffect extends X2Effect; //when applied, this effect reloads target's primary weapon

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item WeaponState, NewWeaponState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		TargetUnit.SetUnitFloatValue(class'X2Effect_DP_CycleGuns'.default.NextGunValue, 0, eCleanup_BeginTactical);	//making sure the right gun is shot first after each reload
		WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
		if (WeaponState != none)
		{
			NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(WeaponState.Class, WeaponState.ObjectID));
			NewWeaponState.Ammo = NewWeaponState.GetClipSize();
			NewGameState.AddStateObject(NewWeaponState);
		}
	}
}