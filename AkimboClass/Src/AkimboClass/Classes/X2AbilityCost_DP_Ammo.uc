class X2AbilityCost_DP_Ammo extends X2AbilityCost_Ammo;

// This is a custom Ammo Cost class, it's pretty much identical to the vanilla Ammo Cost, 
///except this one always checks and charges ammo from the primary weapon instead of the ability's source weapon
//this is necessary because the secondary (left) pistol has infinite ammo, so any ability that uses secondary inventory slot as source 
//(to properly deal damage and apply various attachment and stat bonuses)
//would not apply its ammo cost correctly

//this part works
simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local XComGameState_Item Weapon;

	Weapon = ActivatingUnit.GetItemInSlot(eInvSlot_PrimaryWeapon);
		if (Weapon != none)
		{
			if (Weapon.Ammo >= iAmmo)
				return 'AA_Success';
		}	

	return 'AA_CannotAfford_AmmoCost';
}

//this part works in a weird way... or normally?
simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit Unit;
	local XComGameState_Item Weapon, NewWeaponState;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	Weapon = Unit.GetItemInSlot(eInvSlot_PrimaryWeapon);
	NewWeaponState = XComGameState_Item(NewGameState.ModifyStateObject(Weapon.Class, Weapon.ObjectID));
	
	if (`CHEATMGR != none && `CHEATMGR.bUnlimitedAmmo && Unit.GetTeam() == eTeam_XCom) return;

	kAbility.iAmmoConsumed = iAmmo; //not sure what this even does
	NewWeaponState.Ammo = Weapon.Ammo - iAmmo;
}