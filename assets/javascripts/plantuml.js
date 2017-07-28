/**
 * Extend the jsToolBar function to add the plantUML buttons to editor toolbar.
 * Needs to run after the jsToolbar function is defined and before toolbars are drawn
 *
 * The position cannot be set (see http://www.redmine.org/issues/14936 )
 */
if (typeof(jsToolBar) != 'undefined') {
    jsToolBar.prototype.elements.plantuml = {
        type: 'button',
        title: 'Add PlantUML diagramm',
        fn: {
            wiki: function () {
                // this.singleTag('{{plantuml(png)\n', '\n}}');
                this.encloseLineSelection('{{plantuml(png)\n', '\n}}')
            }
        }
    }
} else {
    throw 'could not add plantUML button to Toolbar. jsToolbar is undefined';
}
