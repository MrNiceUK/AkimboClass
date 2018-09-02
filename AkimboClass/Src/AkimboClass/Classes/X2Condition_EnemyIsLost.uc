class X2Condition_EnemyIsLost extends X2Condition;	//this condition checks if enemy is Lost (and therefore can be headshotted)

var bool EnemyIsLost;	//this variable changes what this condition does. If set to true, condition passes if enemy is Lost. if set to false, condition passes if enemy is not Lost.

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit				TargetUnit;
	
	TargetUnit = XComGameState_Unit(kTarget);

	if(EnemyIsLost)		
	{
		if(TargetUnit.HasSoldierAbility('LostHeadshotInit')) return 'AA_Success';
		else return 'AA_Whatever';
	}
	else
	{
		if(!TargetUnit.HasSoldierAbility('LostHeadshotInit')) return 'AA_Success';
		else return 'AA_Whatever';
	}
}

defaultproperties
{
	EnemyIsLost = true
}

