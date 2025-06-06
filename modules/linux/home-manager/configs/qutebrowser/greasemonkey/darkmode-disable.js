// ==UserScript==
// @name  DarkMode Disable
// @match https://monkeytype.com/*
// @match https://nc.cronyakatsuki.xyz/*
// @match https://company-mode.github.io/*
// @match https://adventofcode.com/*
// @match https://cronyakatsuki.xyz/qbt/*
// @match https://www.keybr.com/*
// @match https://192.168.100:8006/*
// @match https://proxmox.me:8006/*
// ==/UserScript==

const meta = document.createElement("meta");
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
