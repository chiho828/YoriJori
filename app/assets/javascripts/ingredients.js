app.Ingredients = function() {
    this._input = $('#ingredient_search');
    this._initAutocomplete();
};

app.Ingredients.prototype = {
    _initAutocomplete: function() {
        this._input
        .autocomplete({
            source: '/yojo/test',
            appendTo: '#ingredient_results',
            select: $.proxy(this._select, this),
            focus: $.proxy(this._focus, this)
        })
        .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },
    _render: function(ul, item) {
        var markup = [
            '<span class="name">' + item.name + '</span>'
        ];
        return $('<li>')
            .append(markup.join(''))
            .appendTo(ul);
    },
    _select: function(e, ui) {
        this._input.val("");
        
        var item = ui.item;
        console.log(item);
        if (!map.has(item.name)) {
            $('#filters').append('<a onclick="removeFilter(this)">'+item.name+'</a>');
            map.set(item.name, item);
        }
       
        return false;
    },
    _focus: function(e, ui) {
        e.preventDefault();
    }
}