app.Ingredients = function() {
    this._input = $('#ingredient_search');
    this._initAutocomplete();
};

app.Ingredients.prototype = {
    _initAutocomplete: function() {
        this._input
        .autocomplete({
            source: '/yojo/sample_kitchen/1',
            appendTo: '#ingredient_results',
            select: $.proxy(this._select, this)
        })
        .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },
    _select: function(e, ui) {
        this._input.val(ui.item.name);
        return false;
    },
    _render: function(ul, item) {
        console.log("render")
        var markup = [
            '<span class = "name">' + item.name + '</span>'
        ];
        return $('<li>')
            .append(markup.join(''))
            .appendTo(ul);
    }
}