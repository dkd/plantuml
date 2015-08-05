if(typeof(jsToolBar) != 'undefined') {

  jsToolBar.prototype.elements.plantuml = {
    type: 'button',
    after: 'h3',
    title: 'Add PlantUML diagramm',
    fn: {
      wiki: function() {
        this.encloseLineSelection('{{plantuml(png)\n', '\n}}')
      }
    }
  }

}
