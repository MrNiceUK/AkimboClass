class X2Effect_DP_ReserveActionPoints extends X2Effect_ReserveActionPoints;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local int i, Points;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	if( TargetUnitState != none )
	{
		Points = GetNumPoints(TargetUnitState);

		for (i = 0; i < Points; ++i)
		{
			TargetUnitState.ReserveActionPoints.AddItem('overwatch');
		}
		//if(!TargetUnitState.HasSoldierAbility('DP_Quicksilver')) TargetUnitState.ActionPoints.Length = 0; //this is what "ends turn"?
	}
}