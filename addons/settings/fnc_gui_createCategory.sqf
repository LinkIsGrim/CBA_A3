#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_createCategory

Description:
    Creates category for the Addon Options menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>
    _category - Name of category as shown by "ADDON:" listbox, case-sensitive <STRING>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */

params ["_display", "_category"];

if (_category in (_display getVariable QGVAR(createdLists))) exitWith {};

// This is a controls group containing other controls groups
// Each setting needs a control group, and each category needs a control group to hold the groups of settings
private _ctrlOptionsGroup = _display ctrlCreate [QGVAR(OptionsGroup), -1, _display displayCtrl IDC_ADDONS_GROUP];

// Cache the options group so we don't build it more than once per display lifetime
(_display getVariable QGVAR(createdLists)) set [_category, _ctrlOptionsGroup];

private _categorySettings = GVAR(categorySettings) get _selectedAddon;
private _subCategories = GVAR(subCategories) get _selectedAddon;
_subCategories sort true;

// Create all the headers for sub-categories first
// We'll set their position later
{
    private _ctrlHeaderGroup = _display ctrlCreate [QGVAR(subCat), -1, _ctrlOptionsGroup];
    private _ctrlHeaderName = _ctrlHeaderGroup controlsGroupCtrl IDC_SETTING_NAME;
    _ctrlHeaderName ctrlSetText format ["%1:", _x];
    _ctrlOptionsGroup setVariable [format ["%1$%2", QGVAR(header), _x], _ctrlHeaderGroup];
} forEach (keys _subCategories);

{
    [_display, _x] call FUNC(gui_createSetting);
} forEach _categorySettings;


// Set positions
private _allControls = (allControls _ctrlOptionsGroup) select {ctrlType _x == CT_CONTROLS_TABLE};
{
    private _controlsTable = _x;
    if (_controlsTable getVariable "")
} forEach _allControls;
private _lastSubCategory = "$START";

{
    _x params ["_subCategory", "", "_setting"];
    private _createHeader = false;
    if (_subCategory != _lastSubCategory) then {
        _lastSubCategory = _subCategory;
        if (_subCategory == "") exitWith {};
        _createHeader = true;
    };

    (GVAR(default) getVariable _setting) params ["_defaultValue", "", "_settingType", "_settingData", "_category", "_displayName", "_tooltip", "_isGlobal"];

    if (_tooltip != _setting) then { // Append setting name to bottom line
        if (_tooltip isEqualTo "") then {
            _tooltip = _setting;
        } else {
            _tooltip = format ["%1\n%2", _tooltip, _setting];
        };
    };

    private _settingControlsGroups = [];

    {
        private _source = toLower _x;



        // ----- create or retrieve options "list" controls group
        private _list = [QGVAR(list), _category, _source] joinString "$";

        private _ctrlOptionsGroup = controlNull;

        if !(_list in _lists) then {
            _ctrlOptionsGroup = _display ctrlCreate [QGVAR(OptionsGroup), -1, _display displayCtrl IDC_ADDONS_GROUP];
            _ctrlOptionsGroup ctrlEnable false;
            _ctrlOptionsGroup ctrlShow false;

            _lists pushBack _list;
            _display setVariable [_list, _ctrlOptionsGroup];
        } else {
            _ctrlOptionsGroup = _display getVariable _list;
        };








        _ctrlSettingGroup setVariable [QGVAR(setting), _setting];
        _ctrlSettingGroup setVariable [QGVAR(source), _source];
        _ctrlSettingGroup setVariable [QGVAR(params), _settingData];
        _ctrlSettingGroup setVariable [QGVAR(groups), _settingControlsGroups];
        _settingControlsGroups pushBack _ctrlSettingGroup;

        // ----- adjust y position in table
        private _tablePosY = _ctrlOptionsGroup getVariable [QGVAR(tablePosY), TABLE_LINE_SPACING/2];
        _tablePosY = [_ctrlSettingGroup, _tablePosY] call FUNC(gui_controlSetTablePosY);
        _ctrlOptionsGroup setVariable [QGVAR(tablePosY), _tablePosY];

        // ----- padding to make listboxes work
        if (_settingType == "LIST") then {
            private _ctrlEmpty = _display ctrlCreate [QGVAR(Row_Empty), -1, _ctrlOptionsGroup];
            private _height = POS_H(count (_settingData select 0)) + TABLE_LINE_SPACING;
            [_ctrlEmpty, _tablePosY, _height] call FUNC(gui_controlSetTablePosY);
        };



        _display setVariable [[QGVAR(controlGroup), _setting, _source] joinString "$", _ctrlSettingGroup];
        _ctrlSettingGroup setVariable [QGVAR(originalPosition), ctrlPosition _ctrlSettingGroup];
    } forEach ["client", "mission", "server"];
} forEach _categorySettings;
