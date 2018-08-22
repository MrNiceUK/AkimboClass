class X2EventListener_GunKataUI extends X2EventListener config(Akimbo);


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateGunKataUITemplate());

	return Templates;
}

static function X2EventListenerTemplate CreateGunKataUITemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GunKataUI');

	Template.RegisterInTactical = true;
	Template.AddCHEvent('OverrideUnitFocusUI', OnOverrideFocus, ELD_Immediate);

	return Template;
}

//based Robojumper be praised, all of this is his work
static function EventListenerReturn OnOverrideFocus(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local XComLWTuple Tuple;
	local int ReservedAP, MaxAP;
	local string TooltipLong, TooltipShort, Icon;

	Tuple = XComLWTuple(EventData);
	UnitState = XComGameState_Unit(EventSource);

	if (UnitState.GetSoldierClassTemplateName() == 'Akimbo')
	{
		ReservedAP = UnitState.NumReserveActionPoints('overwatch');
		if (ReservedAP == 0)
		{
			Tuple.Data[0].b = false;
			return ELR_NoInterrupt;
		}

		MaxAP = 2;
		if (UnitState.HasSoldierAbility('DP_GunKata_Active')) 
		{
			MaxAP += 2;
			TooltipLong = "Gun Kata Action Points remaining.";
			TooltipShort = "Gun Kata";
			Icon = "img:///WP_Akimbo.UIIcons.FocusMeterIcon32Blue100";
		}
		else
		{
			TooltipLong = "Dual Overwatch Shots remaining.";
			TooltipShort = "Dual Overwatch";
			Icon = "img:///WP_Akimbo.UIIcons.DualOverwatchStatus";
		}

		if (UnitState.HasSoldierAbility('DP_Quicksilver')) MaxAP *= 2;
		if (ReservedAP > MaxAP) MaxAP = ReservedAP;	//in case a reserved action point is granted by threat assessment or something

		Tuple.Data[0].b = true;
		Tuple.Data[1].i = ReservedAP;
		Tuple.Data[2].i = MaxAP;
		Tuple.Data[3].s = "0x0264ab";
		Tuple.Data[4].s = Icon;
		Tuple.Data[5].s = TooltipLong;
		Tuple.Data[6].s = TooltipShort;
	}

	return ELR_NoInterrupt;
}