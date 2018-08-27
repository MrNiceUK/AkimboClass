class X2Condition_OverwatchPacer extends X2Condition config(Akimbo);	
//this condition returns true if the Pacer's Unit Value has been stacked high enough by enemy actions and the soldier is ready to take an overwatch shot

/*
event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;
	local UnitValue OverwatchPacer;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	UnitState.GetUnitValue(class'X2Effect_OverwatchPacer'.default.OverwatchPacerValue, OverwatchPacer);

	if (OverwatchPacer.fValue >= default.OVERWATCH_PACER_TRIGGER) return 'AA_Success';

	return 'AA_Whatever';
}*/
