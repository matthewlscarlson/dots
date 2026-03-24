// use quad9
user_pref("network.trr.mode", 3);
user_pref("network.trr.default_provider_uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.bootstrapAddress", "9.9.9.9");

// keep ipv6 enabled
user_pref("network.dns.disableIPv6", false);

// enable search engines
user_pref("keyword.enabled", true);

// disk caching; placebo(?)
user_pref("browser.cache.disk.enable", true);

// enable favicons
user_pref("browser.shell.shortcutFavicons", true);

// don't use firefox's password manager; it is garbage
user_pref("signon.rememberSignons", false);
user_pref("signon.generation.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);

// pocket is proprietary garbage; get rid of it
user_pref("extensions.pocket.enabled", false);

// disable mozilla account
user_pref("identity.fxaccounts.enabled", false);

// disable reader view
user_pref("reader.parse-on-load.enabled", false);

// disable container tabs
user_pref("privacy.userContext.enabled", false);
user_pref("privacy.userContext.ui.enabled", false);

// no page close confirmation
user_pref("dom.disable_beforeunload", true);

// set downloads dir
user_pref("browser.download.folderList", 2);
user_pref("browser.download.dir", "/home/mc/dl");

// this doesn't do anything
user_pref("privacy.donottrackheader.enabled", true);

// colors
user_pref("browser.display.foreground_color", "#ffffff");
user_pref("browser.display.background_color", "#000000");

// https://wiki.mozilla.org/Firefox/Activity_Stream
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);

// disable safe browsing; it apparently phones home to google
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);

// do not underline links
user_pref("browser.underline_anchors", false);

// use ddg as default search engine, the 'best' of the default search engines
// EDIT: doesn't work
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");

// no suggestions in address bar
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);

// do not warn on quit
user_pref("browser.warnOnQuitShortcut", false);

// hide dictionary
user_pref("extensions.ui.dictionary.hidden", true);
user_pref("extensions.ui.locale.hidden", true);
user_pref("extensions.ui.sitepermission.hidden", true);

// fonts
user_pref("font.minimum-size.x-western", 16);
user_pref("font.name.monospace.x-western", "monospace");
user_pref("font.name.sans-serif.x-western", "sans-serif");
user_pref("font.name.serif.x-western", "serif");
user_pref("font.size.monospace.x-western", 16);

// english is only accepted language
user_pref("intl.accept_languages", "en");

// don't want spell checker
user_pref("layout.spellcheckDefault", 0);

// handle pdf
user_pref("pdfjs.enabledCache.state", false);

// block permissions
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("permissions.default.microphone", 2);
user_pref("permissions.default.xr", 2);
user_pref("media.autoplay.default", 5);
user_pref("media.hardwaremediakeys.enabled", false);

// disable buttons
user_pref("pref.browser.language.disable_button.remove", false);
user_pref("pref.downloads.disable_button.edit_actions", false);
user_pref("pref.privacy.disable_button.cookie_exceptions", false);
user_pref("pref.privacy.disable_button.tracking_protection_exceptions", false);
user_pref("pref.privacy.disable_button.view_passwords_exceptions", false);

// offline website data
user_pref("privacy.cpd.offlineApps", true);

// what to sanitize
user_pref("privacy.sanitize.pending", "[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"offlineApps\",\"history\",\"formdata\",\"downloads\",\"sessions\"],\"options\":{}}]");
user_pref("privacy.clearOnShutdown.offlineApps", true);

// request english for web sites
user_pref("privacy.spoof_english", 2);

// use system theme by default
user_pref("layout.css.prefers-color-scheme.content-override", 2);
