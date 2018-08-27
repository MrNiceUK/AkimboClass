class X2Effect_DP_CycleGuns extends X2Effect; //this class uses a Unit Value to allow single shot abilities alternate between right and left guns

var privatewrite name NextGunValue;

var int NextGunMaster;
var bool UseNextGunMaster;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local UnitValue NextGun;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	if(TargetUnit != none)
	{
		if (UseNextGunMaster)
		{
			TargetUnit.SetUnitFloatValue(default.NextGunValue, NextGunMaster, eCleanup_BeginTactical);
		}
		else
		{
			TargetUnit.GetUnitValue(default.NextGunValue, NextGun);
			if (NextGun.fValue == 0) TargetUnit.SetUnitFloatValue(default.NextGunValue, 1, eCleanup_BeginTactical);	//0 = next shot should come from right hand (main hand)
			else TargetUnit.SetUnitFloatValue(default.NextGunValue, 0, eCleanup_BeginTactical);						//1 = from left
		}
	}

}

defaultproperties
{
	NextGunValue = "NextGunToFire"
	NextGunMaster = 0
	UseNextGunMaster = false
}