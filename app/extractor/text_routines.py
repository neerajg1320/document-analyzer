from pygments.lexers import get_lexer_by_name
from pygments.formatters.html import HtmlFormatter
from pygments import highlight


def create_highlighted_text(text, lexer_name='text', style='friendly', title=None):
    lexer = get_lexer_by_name(lexer_name)
    # linenos = 'table' if self.linenos else False
    linenos = False
    options = {'title': title} if title else {}
    formatter = HtmlFormatter(style=style, linenos=linenos,
                              full=True, **options)
    highlighted = highlight(text, lexer, formatter)
    return highlighted
