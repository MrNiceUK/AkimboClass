class X2Effect_DP_PistolWhipCost extends X2Effect_Persistent;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit, PrevSourceUnit;
	local XComGameState_Ability AbilityState;
	local int j;

	History = `XCOMHISTORY;

	//  if under the effect of Limit Break, let that handle restoring the full action cost
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_DP_LimitBreak'.default.EffectName)) 
	{
		//`Log("IRIDAR Pistol Whip overridden by Limit Break",, 'AkimboClass');
		return false;
	}
						
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	//`Log("IRIDAR Pistol Whip effect triggered by: " @ kAbility.GetMyTemplateName(),, 'AkimboClass');
	
	if (AbilityState != none)
	{
		//works only for Pistol Whip
		if (kAbility.GetMyTemplateName() == 'DP_PistolWhip')
		{
			TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			if (TargetUnit != None)
			{
				PrevSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceUnit.ObjectID));      //  get the most recent version from the history rather than our modified (attacked) version
				if (PrevSourceUnit != None)
				{
					//`Log("IRIDAR Tile distance: " @ PrevSourceUnit.TileDistanceBetween(TargetUnit),, 'AkimboClass');
					if (PrevSourceUnit.TileDistanceBetween(TargetUnit) == 1)
					{
						SourceUnit.ActionPoints = PreCostActionPoints;

						for (j=0; j < SourceUnit.ActionPoints.Length; j++)
						{
							if (SourceUnit.ActionPoints[j] == class'X2CharacterTemplateManager'.default.StandardActionPoint)
							{
								//`Log("IRIDAR Removing one standard action point",, 'AkimboClass');
								SourceUnit.ActionPoints.Remove(j, 1);
								return true;
							}
						}
					}
				}
			}
		}
	}
	return false;
}