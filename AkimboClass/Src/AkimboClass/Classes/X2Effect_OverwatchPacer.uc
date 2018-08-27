class X2Effect_OverwatchPacer extends X2Effect; //this class is used to stack a unit value on the soldier to create artificial delays between multiple overwatch shots
												//without this pacer several overwatch shots would attempt to trigger at the same time, causing a lockup (game unresponsive)
var privatewrite name OverwatchPacerValue;

var int OverwatchPacerMaster;
var bool UseOverwatchPacerMaster;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local UnitValue OverwatchPacer;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	if(TargetUnit != none)
	{
		if (UseOverwatchPacerMaster)
		{
			TargetUnit.SetUnitFloatValue(default.OverwatchPacerValue, OverwatchPacerMaster, eCleanup_BeginTactical);
		}
		else
		{
			TargetUnit.GetUnitValue(default.OverwatchPacerValue, OverwatchPacer);		
			TargetUnit.SetUnitFloatValue(default.OverwatchPacerValue, OverwatchPacer.fValue + 1, eCleanup_BeginTactical);		
		}
	}
}

//				TargetUnit.SetUnitFloatValue(class'X2Effect_OverwatchPacer'.default.OverwatchPacerValue, 0, eCleanup_BeginTactical);

defaultproperties
{
	OverwatchPacerValue = "OverwatchPacer"
	OverwatchPacerMaster = 0
	UseOverwatchPacerMaster = false
}