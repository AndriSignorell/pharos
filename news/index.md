# Changelog

## pharos 0.0.0.954

### New features

- Graphics layer of the DescToolsX package suite, built on base
  graphics: distribution and density displays, bivariate and categorical
  plots, diagnostic and model evaluation panels.
- A theme system ([`theme()`](../reference/theme.md),
  [`style()`](../reference/style.md)) resolves colours, symbols and
  layout centrally, so the appearance of a whole analysis is set once
  rather than at every call.
- [`plotFacet()`](../reference/plotFacet.md) arranges panels from a
  user-supplied panel function and is the mechanism the other packages
  of the suite draw their multi-panel diagnostics with.
- Supporting toolkits for colour conversion and palettes, plot geometry,
  number and string formatting, and HTML output.
- Performance-critical routines are implemented in C++ via Rcpp.

### Acknowledgements

Parts of the code and documentation were reviewed with the help of large
language models (OpenAI Codex, Anthropic Claude). Every suggestion was
assessed, edited and verified by the maintainer, who remains solely
responsible for the content of this package.
