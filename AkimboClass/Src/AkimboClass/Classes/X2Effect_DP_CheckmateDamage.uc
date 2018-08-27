class X2Effect_DP_CheckmateDamage extends X2Effect_DeadeyeDamage config(Akimbo);

var config float CHECKMATE_DAMAGE_MULTIPLIER;
var config float LEG_SHOT_DAMAGE_MULTIPLIER;
var config float TRICK_SHOT_DAMAGE_MULTIPLIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local float ExtraDamage;

	if(class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if (AbilityState.GetMyTemplateName() == 'DP_Checkmate')
		{
			ExtraDamage = CurrentDamage * default.CHECKMATE_DAMAGE_MULTIPLIER;
		}
		if (AbilityState.GetMyTemplateName() == 'DP_LegShot' || AbilityState.GetMyTemplateName() == 'DP_LegShotSecondary')
		{
			ExtraDamage = -1  * CurrentDamage * default.LEG_SHOT_DAMAGE_MULTIPLIER;
		}
		if (AbilityState.GetMyTemplateName() == 'DP_TrickShot')
		{
			ExtraDamage = CurrentDamage * default.TRICK_SHOT_DAMAGE_MULTIPLIER;
		}
		
	}
	return int(ExtraDamage);
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
