local wezterm = require 'wezterm'
return {
        use_ime = true,
        font_size = 16.0,
        color_scheme = 'Gogh (Gogh)',
        hide_tab_bar_if_only_one_tab = true,
        adjust_window_size_when_changing_font_size = false,
        scrollback_lines = 8192,
        enable_scroll_bar = true,
        font = wezterm.font_with_fallback {
                'Fira Code',
                'JetBrains Mono',
        },
        keys = {
                {
                        key = '-',
                        mods = 'ALT',
                        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
                },
                {
                        key = '\\',
                        mods = 'ALT',
                        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
                },
                {
                        key = "h", 
                        mods = "ALT|SHIFT",
                        action = wezterm.action({ ActivatePaneDirection = "Left" })
                },
                {
                        key = "l",
                        mods = "ALT|SHIFT",
                        action = wezterm.action({ ActivatePaneDirection = "Right" })
                },
                {
                        key = "k",
                        mods = "ALT|SHIFT",
                        action = wezterm.action({ ActivatePaneDirection = "Up" })
                },
                {
                        key = "j",
                        mods = "ALT|SHIFT",
                        action = wezterm.action({ ActivatePaneDirection = "Down" })
                },
        }
}
