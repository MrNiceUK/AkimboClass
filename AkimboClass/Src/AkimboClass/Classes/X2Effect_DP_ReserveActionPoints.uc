class X2Effect_DP_ReserveActionPoints extends X2Effect_ReserveActionPoints config(Akimbo);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local int i, Points;

	TargetUnitState = XComGameState_Unit(kNewTargetState);

	if( TargetUnitState != none )
	{
		Points = GetNumPoints(TargetUnitState);	//why does this need a Unit State?!

		if (class'X2Condition_DP_DualPistols'.static.IsPrimaryPistolWeaponTemplate(X2WeaponTemplate(TargetUnitState.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState).GetMyTemplate()))) 
		{
			Points *= 2;	//if the soldier is using Gun Kata or Dual Overwatch with a pistol equipped in the primary weapon slot, it grants twice as many overwatch action points
		}

		for (i = 0; i < Points; ++i)
		{
			TargetUnitState.ReserveActionPoints.AddItem('overwatch');
		}
		//if(!TargetUnitState.HasSoldierAbility('DP_Quicksilver')) TargetUnitState.ActionPoints.Length = 0; //this is what "ends turn"?
	}
}