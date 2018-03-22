app.SearchIngredients = function() {
    this._input = $('#ingredient_search');
    this._initAutocomplete();
};

app.YoriIngredients = function() {
    this._input = $('#ingredient_search');
    this._initAutocomplete();
};

app.SearchIngredients.prototype = {
    _initAutocomplete: function() {
        this._input
        .autocomplete({
            source: '/',
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
            $('#filters').append('<span onclick="removeFilter(this)">'+item.name+'</span>');
            map.set(item.name, item.id);
        }
        
        console.log(map);
       
        return false;
    },
    _focus: function(e, ui) {
        e.preventDefault();
    }
}

app.YoriIngredients.prototype = {
    _initAutocomplete: function() {
        this._input
        .autocomplete({
            source: '/',
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
        
        if (!map.has(item.name)) {
            $('#new_yori_ingredients').append('<div class="row" id="'+item.name+'"> \
                <div class="col-lg-1"> \
                    <input class="main_ingredient" type="checkbox"> \
                </div> \
                <div class="col-lg-1"> \
                    <input class="seasoning" type="checkbox"> \
                </div> \
                <div class="col-lg-2"> \
                    <div class="ingredient_name">'+item.name+'</div> \
                </div> \
                <div class="col-lg-1.5"> \
                    <input class="quantity" type="text" size="6"> \
                </div> \
                <div class="col-lg-1"> \
                    <select class="unit"> \
                        <option>g</option> \
                        <option>ml</option> \
                        <option>개</option> \
                        <option>스푼</option> \
                        <option>조금</option> \
                    </select> \
                </div> \
                <button onclick="removeRow(this)">빼기</button> \
            </div>');
            map.set(item.name, item.id);
        }
        
        return false;
    },
    _focus: function(e, ui) {
        e.preventDefault();
    }
}