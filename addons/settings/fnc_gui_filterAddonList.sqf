#include "script_component.hpp"

#define SETTING_NAME (_settingInfo get "displayName")
#define SETTING_TOOLTIP (_settingInfo get "tooltip")
#define SETTING_VARIABLE (_settingInfo get "setting")
#define SETTING_TYPE (_settingInfo get "settingType")
#define SETTING_DATA (_settingInfo get "settingData")

params ["_control", "_searchPattern"];

private _categories = [];
private _selectedCategory = uiNamespace getVariable [QGVAR(addon), ""];
for "_i" from (lbSize _control) - 1 to 0 step - 1 do {
    private _category = _control lbText _i;

    // Early skip if the category title matches or this is the currently selected category
    // Handling for no matches in category settings is in FUNC(gui_handleSettingSearchbar)
    if (
        _category == _selectedCategory ||
        {_category regexMatch _searchPattern}
    ) then {
        _categories pushBack _category; continue
    };

    {
        private _settingInfo = GVAR(allSettingsData) get _x;
        private _showCategory = ([SETTING_NAME, SETTING_TOOLTIP, SETTING_VARIABLE] findIf {_x regexMatch _searchPattern}) != -1;
        if (!_showCategory && {SETTING_TYPE == "LIST"}) then {
            private _labels = SETTING_DATA param [1, []];
            _showCategory = (_labels findIf {_x regexMatch _searchPattern}) != -1;
        };
        if (_showCategory) then {
            _categories pushBack _category;
            break
        };
    } forEach (GVAR(categorySettings) get _category);

    if !(_category in _categories) then {
        diag_log format ["removed category: %1", _category];
        _control lbDelete _i;
    };
};
