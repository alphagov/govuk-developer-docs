//= require mermaid
//= require svg-toolbelt.cjs.production.min.js

// If we are rendering a diagram, a code tag is no longer appropriate, so change it to a div
const mermaidCodeBlocks = document.querySelectorAll('[lang="mermaid"] code')
mermaidCodeBlocks.forEach((codeNode) => {
  const replacementDivNode = document.createElement('div')
  replacementDivNode.innerHTML = codeNode.innerHTML
  replacementDivNode.className = "mermaid"

  codeNode.replaceWith(replacementDivNode)
})

mermaid.initialize({ startOnLoad: false });
mermaid.run({
  querySelector: '[lang="mermaid"] div',
  // Large mermaid diagrams render very small indeed in the manual, so use svg-toolbelt
  // to give zoom & pan controls
  postRenderCallback: (id) => {
    const container = document.getElementById(id)
    new SvgToolbelt.SvgToolbelt(container.closest("div.mermaid"), {}).init()
  }
})

