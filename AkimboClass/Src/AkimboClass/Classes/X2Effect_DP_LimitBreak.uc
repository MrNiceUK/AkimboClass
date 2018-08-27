class X2Effect_DP_LimitBreak extends X2Effect_Persistent config(Akimbo);

var privatewrite name BonusActionsValue;
var config int LIMIT_BREAK_ACTIONS_BEFORE_DAMAGE;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability AbilityState;
	local UnitValue BonusActions;
	local XComGameStateHistory History;
	local X2EventManager EventMgr;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	if (SourceUnit.NumActionPoints() == 0 && PreCostActionPoints.Length > 0)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if (AbilityState != none)
		{
			//`Log("IRIDAR Granting bonus AP",, 'AkimboClass');
			SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			SourceUnit.GetUnitValue(default.BonusActionsValue, BonusActions);
			//`Log("IRIDAR BonusActionsValue: " @ BonusActions.fValue,, 'AkimboClass');
			SourceUnit.SetUnitFloatValue(default.BonusActionsValue, BonusActions.fValue + 1, eCleanup_Never);
			
			if (BonusActions.fValue + 1 > default.LIMIT_BREAK_ACTIONS_BEFORE_DAMAGE) EventMgr.TriggerEvent('DP_LimitBreak_SelfDamage', AbilityState, SourceUnit, NewGameState);
			return true;
		}
	}
	return false;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit UnitState;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	//`XEVENTMGR.TriggerEvent('DP_LimitBreak_DealSoakedDamage', AbilityState, AbilityState, NewGameState);	
	`XEVENTMGR.TriggerEvent('DP_LimitBreak_DealSoakedDamage', UnitState, UnitState);
}
/*
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit SourceUnitState;
	local XComGameStateHistory History;
	local Object EffectObj;
	local int i;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', static.DP_LimitBreak_SoakDamage, ELD_OnStateSubmitted,, EffectObj,, EffectObj);
}

static function EventListenerReturn DP_LimitBreak_SoakDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local X2Effect_Sustained SustainedEffectTemplate;
	local UnitValue LastEffectDamage;
	local XComGameState_Unit SustainedEffectSourceUnit;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local X2TacticalGameRuleset TacticalRules;
	local float DamageTakenThisFullTurn;

	`Log("IRIDAR DP_LimitBreak_SoakDamage triggered",, 'AkimboClass');

	History = `XCOMHISTORY;

	SustainedEffectSourceUnit = XComGameState_Unit(CallbackData);
	SustainedEffectSourceUnit.GetUnitValue('LastEffectDamage', LastEffectDamage);
	`Log("IRIDAR Last effect damage: " @ LastEffectDamage.fValue,, 'AkimboClass');

	DamageTakenThisFullTurn += LastEffectDamage.fValue;
	`Log("IRIDAR Damage taken this turn: " @ DamageTakenThisFullTurn,, 'AkimboClass');

	NewGameState = History.CreateNewGameState(true, EffectRemovedState);

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		TacticalRules = `TACTICALRULES;
		TacticalRules.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}*/

/*
	native function RegisterForEvent( 
									ref Object SourceObj, 
                                    Name EventID, 
                                    delegate<OnEventDelegate> NewDelegate, 
                                    optional EventListenerDeferral Deferral=ELD_Immediate, 
                                    optional int Priority=50, 
                                    optional Object PreFilterObject, 
                                    optional bool bPersistent, 
                                    optional Object CallbackData );
	
	
	As for RegisterForEvent, for your future reference, the first argument is the object from which to call the delegate (generally self by way of a temp Object variable, because you cant pass self directly), the EventID is the name of the event you want to trigger your response function, NewDelegate is the function you want to run, deferral is when you want it to run (generally ELD_Immediate, unless you’re trying to make changes to a state and require the changes from the thing you’re interrupting to be saved before you access them), and the rest are black magic to me
IridarToday at 9:44 PM
where should be the function that I want to run? can i define it in the same X2Effect class?
i'll likely end up using events anyway
GingerToday at 9:48 PM
If you are registering for the event in the same class the function to run is in, SourceObj is self and NewDelegate is just the function name. This is how its generally done
*/

/*

function static EventListenerReturn DP_LimitBreak_SoakDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local UnitValue LastEffectDamage;
	local XComGameState_Unit SourceUnit;

	//SourceUnit = XComGameState_Unit(CallbackData);
	//SourceUnit.GetUnitValue('LastEffectDamage', LastEffectDamage);

	`Log("IRIDAR Took damage: ",, 'AkimboClass');
	
	//restore health equal to LastEffectDamage.fValue

	//record LastEffectDamage.fValue in unit value

	return ELR_NoInterrupt;
}*/
/*
function EventListenerReturn OnSourceUnitTookEffectDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local X2Effect_Sustained SustainedEffectTemplate;
	local UnitValue LastEffectDamage;
	local XComGameState_Unit SustainedEffectSourceUnit;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local X2TacticalGameRuleset TacticalRules;

	// If this effect is already removed, don't do it again
	if( !bRemoved )
	{
		History = `XCOMHISTORY;

		SustainedEffectTemplate = X2Effect_Sustained(GetX2Effect());
		//removed assert, this function is now used also for other effects other than sustained effects.
		//`assert(SustainedEffectTemplate != none);
		if(SustainedEffectTemplate != none)
		{
			SustainedEffectSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			SustainedEffectSourceUnit.GetUnitValue('LastEffectDamage', LastEffectDamage);

			DamageTakenThisFullTurn += LastEffectDamage.fValue;
			if (!(SustainedEffectTemplate.FragileAmount > 0 && (DamageTakenThisFullTurn >= SustainedEffectTemplate.FragileAmount)))
			{
				// The sustained effect's source unit has not taken enough damge, the sustain is kept, we just break out
				return ELR_NoInterrupt;
			}
		}

		EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(self);
		NewGameState = History.CreateNewGameState(true, EffectRemovedState);
		RemoveEffect(NewGameState, GameState);

		if( NewGameState.GetNumGameStateObjects() > 0 )
		{
			TacticalRules = `TACTICALRULES;
			TacticalRules.SubmitGameState(NewGameState);
			//  effects may have changed action availability - if a unit died, took damage, etc.
		}
		else
		{
			History.CleanupPendingGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}*/


DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	BonusActionsValue = "DP_BonusActionsValue"
	EffectName = "DP_LimitBreak"
}
