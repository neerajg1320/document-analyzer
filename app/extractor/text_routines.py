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


import re
from collections import OrderedDict


def debug_extraction_processing():
    return False


def create_transactions_from_text_tuples_str(transaction_regex_str, input_str):

    pattern = re.compile(transaction_regex_str, re.MULTILINE)
    matches = pattern.finditer(input_str)

    # We get the list of group names and they can be sorted by their index
    fields = sorted(pattern.groupindex.items(), key=lambda x: x[1])

    extracted_rows = []

    for match_num, match in enumerate(matches):
        match_num = match_num + 1

        if debug_extraction_processing():
            print("")
            print("Match {match_num} was found at {start}-{end}:".format(match_num = match_num, start = match.start(), end = match.end()))
            print("{match}".format(match = match.group()))
        for group_num in range(0, len(match.groups())):
            group_num = group_num + 1
            if debug_extraction_processing():
                print("Group {group_num} found at {start}-{end}: {group}".format(group_num = group_num, start = match.start(group_num), end = match.end(group_num), group = match.group(group_num)))

        extracted_rows.append(tuple([match.groupdict()[f[0]] for f in fields]))

        # match.groupdict() has group_name and value pair but they are not in order.
        # We get the order from fields as a sorted tuple and then create an OrderedDict accordingly
        extracted_group_dict = OrderedDict([(f[0], match.groupdict()[f[0]]) for f in fields])

        if debug_extraction_processing():
            print("Group Dictionary:\n" + str(extracted_group_dict))

    ret_str = str(tuple([f[0] for f in fields]))
    for row in extracted_rows:
        ret_str += "\n" + str(row)

    if debug_extraction_processing():
        print(ret_str)

    # From here on it should be a common path
    return ret_str


def create_transactions_dict_array_from_text(transaction_regex_str, input_str):

    pattern = re.compile(transaction_regex_str, re.MULTILINE)
    matches = pattern.finditer(input_str)

    # We get the list of group names and they can be sorted by their index
    fields = sorted(pattern.groupindex.items(), key=lambda x: x[1])

    extracted_dict_array = []

    for match_num, match in enumerate(matches):
        match_num = match_num + 1

        if debug_extraction_processing():
            print("")
            print("Match {match_num} was found at {start}-{end}:".format(match_num = match_num, start = match.start(), end = match.end()))
            print("{match}".format(match = match.group()))
        for group_num in range(0, len(match.groups())):
            group_num = group_num + 1
            if debug_extraction_processing():
                print("Group {group_num} found at {start}-{end}: {group}".format(group_num = group_num, start = match.start(group_num), end = match.end(group_num), group = match.group(group_num)))

        # match.groupdict() has group_name and value pair but they are not in order.
        # We get the order from fields as a sorted tuple and then create an OrderedDict accordingly
        extracted_group_dict = OrderedDict([(f[0], match.groupdict()[f[0]]) for f in fields])

        if debug_extraction_processing():
            print("Group Dictionary:\n" + str(extracted_group_dict))

        extracted_dict_array.append(extracted_group_dict)

    # From here on it should be a common path
    return extracted_dict_array
