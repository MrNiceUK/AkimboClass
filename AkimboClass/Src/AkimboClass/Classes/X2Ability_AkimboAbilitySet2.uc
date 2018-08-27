class X2Ability_AkimboAbilitySet2 extends X2Ability config(Akimbo);	//NOT IN USE CURRENTLY
//class X2Ability_AkimboAbilitySet extends X2Ability;

/*
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	
	//Templates.AddItem(Create_DP_TakeInitiativeStrike2());
	//Templates.AddItem(Create_DP_TakeInitiativeStrikeLeft2());

	//Templates.AddItem(Create_DP_DualShot2());
	//Templates.AddItem(Create_DP_DualShotSecondary2());


	//Templates.AddItem(Create_DP_PistolWhip2());
	//Templates.AddItem(Create_DP_PistolWhipSecondary2());

	return Templates;
}*/

/*
	Template.AdditionalAbilities.AddItem('DP_TakeInitiativeStrike2');
	Template.AdditionalAbilities.AddItem('DP_TakeInitiativeStrikeLeft2');



*/
static function X2AbilityTemplate Create_DP_PistolWhip2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;

	Template = class'X2Ability_AkimboAbilitySet'.static.PistolWhip('DP_PistolWhip2', "DualRight");

	Template.IconImage = "img:///WP_Akimbo.UIIcons.PistolWhip";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AdditionalAbilities.AddItem('DP_PistolWhipSecondary2');
	Template.PostActivationEvents.AddItem('DP_PistolWhipSecondary2');

	//Template.DamagePreviewFn = PistolWhipDamagePreview;
	Template.MergeVisualizationFn = SkulljackCounterMergeVisualization;
	Template.CustomFireAnim = 'CQCSupremacy';
	Template.CustomFireKillAnim = 'CQCSupremacyKill';

	return Template;
}


static function X2AbilityTemplate Create_DP_PistolWhipSecondary2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener	AbilityTrigger;

	Template = class'X2Ability_AkimboAbilitySet'.static.PistolWhip('DP_PistolWhipSecondary2', "DualLeft");

	AbilityTrigger = new class'X2AbilityTrigger_EventListener';
	AbilityTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	AbilityTrigger.ListenerData.EventID = 'DP_PistolWhipSecondary2';
	AbilityTrigger.ListenerData.Filter = eFilter_Unit;
	AbilityTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(AbilityTrigger);

	Template.ActionFireClass = class'X2Action_DelayedFireAction';
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	return Template;
}

static function X2AbilityTemplate Create_DP_DualShot2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;

	Template = class'X2Ability_AkimboAbilitySet'.static.SingleShot('DP_DualShot2', "Right");

	Template.IconImage = "img:///WP_Akimbo.UIIcons.DualShot";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	Template.AbilityCosts.AddItem(ActionPointCost);



	Template.AdditionalAbilities.AddItem('DP_DualShotSecondary2');
	Template.PostActivationEvents.AddItem('DP_DualShotSecondary2');

	return Template;
}

static function X2AbilityTemplate Create_DP_DualShotSecondary2()
{
	local X2AbilityTemplate	Template;
	local X2AbilityTrigger_EventListener    Trigger;

	Template = class'X2Ability_AkimboAbilitySet'.static.SingleShot('DP_DualShotSecondary2', "Left");

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'DP_DualShotSecondary';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.MergeVisualizationFn = SkulljackCounterMergeVisualization;

	return Template;
}

/*
static function X2AbilityTemplate Create_DP_TakeInitiativeStrike2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener	AbilityTrigger;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;

	Template = class'X2Ability_AkimboAbilitySet2'.static.SingleShot('DP_TakeInitiativeStrike2', "Right");

	AbilityTrigger = new class'X2AbilityTrigger_EventListener';
	AbilityTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	AbilityTrigger.ListenerData.EventID = 'DP_TakeInitiativeStrike';
	AbilityTrigger.ListenerData.Filter = eFilter_Unit;
	AbilityTrigger.ListenerData.EventFn = class'X2Ability_AkimboAbilitySet'.static.TakeInitiativeListener;
	Template.AbilityTriggers.AddItem(AbilityTrigger);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'BladestormTarget';	//we don't care about effect name, since condition will check who applied it, so it won't interfere with actual Bladestorms from other soldiers
	BladestormTargetEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(BladestormTargetEffect);
	
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('BladestormTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);


	Template.BuildVisualizationFn = class'X2Ability_AkimboAbilitySet'.static.TakeInitiative_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;

	Template.PostActivationEvents.AddItem('DP_TakeInitiativeStrikeLeft2');

	return Template;
}
static function X2AbilityTemplate Create_DP_TakeInitiativeStrikeLeft2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener	AbilityTrigger;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;

	Template = class'X2Ability_AkimboAbilitySet2'.static.SingleShot('DP_TakeInitiativeStrikeLeft2', "Left");

	AbilityTrigger = new class'X2AbilityTrigger_EventListener';
	AbilityTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	AbilityTrigger.ListenerData.EventID = 'DP_TakeInitiativeStrike';
	AbilityTrigger.ListenerData.Filter = eFilter_Unit;
	AbilityTrigger.ListenerData.EventFn = class'X2Ability_AkimboAbilitySet'.static.TakeInitiativeListener;
	Template.AbilityTriggers.AddItem(AbilityTrigger);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'BladestormTarget2';
	BladestormTargetEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(BladestormTargetEffect);
	
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('BladestormTarget2', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	Template.BuildVisualizationFn = class'X2Ability_AkimboAbilitySet'.static.TakeInitiative_BuildVisualization;

	Template.PostActivationEvents.AddItem('DP_TakeInitiativeStrike2');

	return Template;
}

static function X2AbilityTemplate Create_DP_DualShot2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;

	Template = class'X2Ability_AkimboAbilitySet'.static.SingleShot('DP_DualShot2', "DualRight");

	Template.IconImage = "img:///WP_Akimbo.UIIcons.DualShot";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.OverrideAbilities.AddItem('PistolStandardShot');
	Template.bOverrideWeapon = true;


	Template.MergeVisualizationFn = LightsaberDeflectShotMergeVisualization;

	Template.AdditionalAbilities.AddItem('DP_DualShotSecondary2');
	Template.PostActivationEvents.AddItem('DP_DualShotSecondary2');

	return Template;
}

static function X2AbilityTemplate Create_DP_DualShotSecondary2()
{
	local X2AbilityTemplate	Template;
	local X2AbilityTrigger_EventListener    Trigger;

	Template = class'X2Ability_AkimboAbilitySet'.static.SingleShot('DP_DualShotSecondary2', "DualLeft");

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'DP_DualShotSecondary';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	//Template.MergeVisualizationFn = LightsaberDeflectShotMergeVisualization;
	//Template.ActionFireClass = class'X2Action_DelayedFireAction';

	Template.PostActivationEvents.AddItem('DP_TakeInitiativeStrike2');

	return Template;
}



// **************************************************************************
// ***                            SHARED CODE                             ***
// **************************************************************************


//basic template for single shots that come from only one weapon, it has no triggers and no costs besides ammo
static function X2AbilityTemplate SingleShot(name TemplateName, string Hand)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_DP_Ammo             AmmoCost;
	local X2Effect_Shredder			        WeaponDamageEffect;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_DP_CycleGuns				CycleGunsEffect;
	local X2Condition_DP_CycleGuns			CycleGunsCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standardpistol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailableOrNoTargets;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';    // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	AmmoCost = new class'X2AbilityCost_DP_Ammo';	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	if (Hand == "Right")
	{
		Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
		Template.CustomFireAnim = 'FF_SingleShotRight';
		AmmoCost.iAmmo = 1;
	}
	if (Hand == "Left")
	{
		Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;
		Template.CustomFireAnim = 'FF_SingleShotLeft';
		AmmoCost.iAmmo = 1;
	}
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); 	// Status condtions that do *not* prohibit this action.
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityCosts.AddItem(AmmoCost);
	 
	// Weapon Upgrade Compatibility
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;
	Template.bAllowFreeFireWeaponUpgrade = true;  //Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage); //guaranteed damage on missed shots attachment (stock)

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AssociatedPassives.AddItem('HoloTargeting');

	Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

	WeaponDamageEffect = new class'X2Effect_Shredder';	//this will shred only if the soldier actually has the Shredder ability, otherwise it behaves identically to ApplyWeaponDamage
	WeaponDamageEffect.bAllowFreeKill = true;	//allow Repeater instakill
	Template.AddTargetEffect(WeaponDamageEffect);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
		
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	//Template.BuildNewGameStateFn = class'X2Ability_AkimboAbilitySet'.static.DualPistols_BuildGameState;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;	
}*/


function SkulljackCounterMergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
    local XComGameStateVisualizationMgr VisMgr;
    local X2Action_DelayedFireAction SecondHitFire;
    local X2Action_Fire FirstHitFire;
    local X2Action_EnterCover TargetEnterCover;
    local X2Action_ApplyWeaponDamageToUnit SecondHitReact;
    local X2Action_MarkerTreeInsertBegin InsertHere;
    local Actor SourceUnit;
    local Actor TargetUnit;
 
    VisMgr = `XCOMVISUALIZATIONMGR;
 
    SecondHitFire = X2Action_DelayedFireAction(VisMgr.GetNodeOfType(BuildTree, class'X2Action_DelayedFireAction'));
    SourceUnit = SecondHitFire.Metadata.VisualizeActor;
    SecondHitReact = X2Action_ApplyWeaponDamageToUnit(VisMgr.GetNodeOfType(BuildTree, class'X2Action_ApplyWeaponDamageToUnit'));
    TargetUnit = SecondHitReact.Metadata.VisualizeActor;
 
    FirstHitFire = X2Action_Fire(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_Fire', SourceUnit));
    TargetEnterCover = X2Action_EnterCover(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_EnterCover', TargetUnit));
 
    // First let's link the starts of our trees
    InsertHere = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_MarkerTreeInsertBegin'));
    VisMgr.ConnectAction(BuildTree, VisualizationTree, false, InsertHere);
 
    // Now Make the second hit follow the first hit
    VisMgr.ConnectAction(SecondHitFire, VisualizationTree, false, FirstHitFire);
 
    // The Target needs to wait to enter cover until after the attack
    VisMgr.ConnectAction(TargetEnterCover, VisualizationTree, false, SecondHitReact);
}