import operator

from qutebrowser.api import interceptor, message

REDIRECT_MAP = {
    "reddit.com": operator.methodcaller("setHost", "libreddit.cronyakatsuki.xyz"),
    "old.reddit.com": operator.methodcaller("setHost", "libreddit.cronyakatsuki.xyz"),
    "www.reddit.com": operator.methodcaller("setHost", "libreddit.cronyakatsuki.xyz"),
    "twitter.com": operator.methodcaller("setHost", "nitter.cronyakatsuki.xyz"),
    "www.twitter.com": operator.methodcaller("setHost", "nitter.cronyakatsuki.xyz"),
    "music.youtube.com": operator.methodcaller(
        "setHost", "hyperpipe.cronyakatsuki.xyz"
    ),
    "twitch.tv": operator.methodcaller("setHost", "safetwitch.cronyakatsuki.xyz"),
    "www.twitch.tv": operator.methodcaller("setHost", "safetwitch.cronyakatsuki.xyz"),
    "tiktok.com": operator.methodcaller("setHost", "proxytok.cronyakatsuki.xyz"),
    "www.tiktok.com": operator.methodcaller("setHost", "proxytok.cronyakatsuki.xyz"),
    "imgur.com": operator.methodcaller("setHost", "rimgo.cronyakatsuki.xyz"),
    "www.imgur.com": operator.methodcaller("setHost", "rimgo.cronyakatsuki.xyz"),
    "github.com": operator.methodcaller("setHost", "gh.cronyakatsuki.xyz"),
    "gist.github.com": operator.methodcaller("setHost", "gh.cronyakatsuki.xyz/gist"),
}


def int_fn(info: interceptor.Request):
    url = info.request_url
    redir = REDIRECT_MAP.get(url.host())
    if redir is not None and redir(url) is not False:
        message.info("Redirecting to " + url.toString())
        info.redirect(url)


interceptor.register(int_fn)
