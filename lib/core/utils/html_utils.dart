/// Lightweight helpers for the HTML snippets the CMS returns
/// (product descriptions/specifications), so no HTML renderer is needed.
class HtmlUtils {
  HtmlUtils._();

  static final _imgSrc = RegExp(r'''<img[^>]+src=["']([^"']+)["']''', caseSensitive: false);
  static final _blockBreak = RegExp(r'</(p|div|li|h[1-6])>|<br\s*/?>', caseSensitive: false);
  static final _tag = RegExp(r'<[^>]+>');

  static List<String> imageUrls(String? html) {
    if (html == null) return [];
    return _imgSrc.allMatches(html).map((m) => m.group(1)!).toList();
  }

  /// Converts HTML to non-empty plain-text lines.
  static List<String> toLines(String? html) {
    if (html == null || html.isEmpty) return [];
    final text = html
        .replaceAll(_blockBreak, '\n')
        .replaceAll(_tag, '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
    return text
        .split('\n')
        .map((l) => l.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((l) => l.isNotEmpty)
        .toList();
  }

  static String toText(String? html) => toLines(html).join('\n');
}
