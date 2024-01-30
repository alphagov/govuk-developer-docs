# enable all linting rules by default, then override below
all

# Some files hard-wrap lines to around 80 characters, others do not. We don't
# have a definitive guide in the GDS Way, so we shouldn't enforce either way here.
exclude_rule "line-length"

# Middleman starts .md files with Frontmatter (https://middlemanapp.com/basics/frontmatter/)
# which describe the title of the page, category, review date and so on.
# Thus we don't need to define the title of the page with a header.
exclude_rule "first-line-h1"
exclude_rule "first-header-h1"

# Some documents may want to be explicit about the step numbers so that they
# can refer to them later. For example, "go back to step 3 and repeat".
# In those cases, forcing every item to be prefixed with `1` is unhelpful.
exclude_rule "ol-prefix"

# Sometimes we use code blocks to show example log file content or console
# output, so a particular syntax highlight would not be appropriate. We should
# leave it to the developer to decide whether or not a code language should
# be provided.
exclude_rule "fenced-code-language"

# We've historically been inconsistent in avoiding the leading `$` in shell
# examples: some have the extraneous `$` and some don't.
exclude_rule "commands-show-output"

# At time of writing, this rule is quite buggy.
#
# 1.
#   - Foo
#   - Bar
#
# ...and then later on in the doc:
#
# - Baz
#
# ...it will complain that the `-` isn't at the same indentation level as the ones
# encountered earlier. But this is deliberate because the previous hyphens were
# sublists within the `1.` numbered list.
#
# So, better to turn the rule off for now.
exclude_rule "list-indent"

# Some pages, such as the "Architectural deep-dive of GOV.UK", break into
# sections which all follow the same format, e.g.
#
# ## Foo
# ### Problem
# ### Solution
# ## Bar
# ### Problem
# ### Solution
#
# This seems a reasonable thing to be able to do and so we leave it up to
# developers' discretion.
exclude_rule "no-duplicate-header"

# This is quite an opinionated rule that disallows characters like
# !, ? or : at the end of headings.
# We use these in various places and it's not clear what benefit there is
# to disallowing them.
exclude_rule "no-trailing-punctuation"

# This rule should be triggered when blockquotes have more than one space
# after the blockquote (>) symbol. However, it's a bit buggy, and fails for
# markdown like this:
#
# > Foo
# > [bar](https://example.com) baz
#
# ...so best to disable it.
exclude_rule "no-multiple-space-blockquote"

# This rule errors if it encounters a bare URL, e.g. https://example.com,
# which is neither in markdown form (`[link](https://example.com`) nor
# wrapped in `<https://example.com>`.
#
# This is a good rule to enable, however we have numerous use cases where
# it isn't appropriate to make the URL linkable. For example, when
# describing dynamic portions of the URL, which the reader should
# substitute for their own use case:
#
# - https://example.com/{YOUR_ORGANISATION_ID}/bla
#
# So, unfortunately, we'll have to exclude the rule.
exclude_rule "no-bare-urls"

# This rule is a little buggy, treating the following URL markdown
# as HTML:
# <https://www.direct.gov.uk/__canary__>
# We also have some legitimate use cases for inline HTML: for instance,
# embedding an iframe on the architecture page.
# So, we'll need to disable the rule. Keep an eye on the 'inline ignore'
# issue: https://github.com/markdownlint/markdownlint/issues/16
# If that is implemented, we'll be able to override the rule only
# in the places we want to allow inline HTML.
exclude_rule "no-inline-html"

# This rule stops us from having correctly rendered nested unordered
# lists within an ordered list.
# It is a known issue with this gem:
# https://github.com/markdownlint/markdownlint/issues/296
exclude_rule "ul-indent"
