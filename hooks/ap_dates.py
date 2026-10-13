"""Rewrite rendered dates into AP style (e.g. "October 8, 2026" -> "Oct. 8, 2026").

Only touches text inside <time> elements (blog post dates) and the
git-revision-date-localized "Last update" span, never regular page content.
"""

import re

AP_MONTHS = {
    "January": "Jan.",
    "February": "Feb.",
    "August": "Aug.",
    "September": "Sept.",
    "October": "Oct.",
    "November": "Nov.",
    "December": "Dec.",
    # March, April, May, June and July are always spelled out in AP style
}

MONTH_RE = re.compile(r"\b(" + "|".join(AP_MONTHS) + r")\b")

DATE_ELEMENT_RE = re.compile(
    r"(<time\b[^>]*>|<span class=\"git-revision-date-localized-plugin[^\"]*\"[^>]*>)"
    r"([^<]*)"
    r"(</time>|</span>)"
)


def _to_ap(match):
    opening, text, closing = match.groups()
    return opening + MONTH_RE.sub(lambda m: AP_MONTHS[m.group(1)], text) + closing


def on_post_page(output, page, config):
    return DATE_ELEMENT_RE.sub(_to_ap, output)
