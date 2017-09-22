// control
vimfx.set('mode.normal.reload_config_file',         '.');

// tab and window
vimfx.set('mode.normal.tab_select_previous',        'b');
vimfx.set('mode.normal.tab_select_next',            'f');
vimfx.set('mode.normal.tab_close',                  'd');
vimfx.set('mode.normal.tab_restore',                'u');

// page navigation
vimfx.set('mode.normal.scroll_half_page_down',      '<C-d>');
vimfx.set('mode.normal.scroll_half_page_up',        '<C-u>');


// hit-a-hint
vimfx.set('mode.normal.follow',                     'e');
vimfx.set('mode.normal.follow_in_tab',              'E');
vimfx.set('mode.normal.follow_in_focused_tab',      ';t');
vimfx.set('mode.normal.follow_in_window',           ';w');
vimfx.set('mode.normal.follow_in_private_window',   ';p');
vimfx.set('mode.normal.follow_copy',                ';y');


// openurl
let register_openurl = function (name, url) {
	vimfx.addCommand({
		name: `openurl_${name}`,
		description: `Open url ${url}`,
		category: 'location',
		order: 500,
	}, ({vim}) => {
		vim.window.gBrowser.loadOneTab(url, { inBackground: false, relatedToCurrent: true });
	});
};
register_openurl('hatebu', 'http://b.hatena.ne.jp/grafi/bookmark');

vimfx.set('custom.mode.normal.openurl_hatebu',      'gh');
