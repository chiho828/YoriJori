app.Seasonings = function() {
    this._input = $('#seasoning_search');
    this._initAutocomplete();
};

app.Seasonings.prototype = {
    _initAutocomplete: function() {
        this._input
        .autocomplete({
            source: '/yojo/sample_kitchen/2',
            appendTo: '#seasoning_results',
            select: $.proxy(this._select, this)
        })
        .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },
    _select: function(e, ui) {
        this._input.val(ui.item.title);
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