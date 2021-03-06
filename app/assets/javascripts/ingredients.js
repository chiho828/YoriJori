app.SearchIngredients = function() {
    this._input = $('#ingredient_search');
    this._initAutocomplete();
};

app.KitchenIngredients = function() {
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
        var filter_name = item.name+" X";
        if (!map.has(filter_name)) {
            $('#filters').append('<span onclick="removeFilter(this)">'+filter_name+'</span>');
            map.set(filter_name, item.id);
        }
        console.log(map);
       
        return false;
    },
    _focus: function(e, ui) {
        e.preventDefault();
    }
}

app.KitchenIngredients.prototype = {
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
        
        var filter_name = item.name+" X";
        if (!map.has(filter_name)) {
            $('#kitchen_list').append('<li id="kitchen_list_li" onclick="removeFilter(this)">'+filter_name+'</li>');
            map.set(filter_name, item.id);
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
            $('#new_yori_ingredients').append('<div class="row" style="display: inline-flex; width: 90%" \
            id="'+item.name+'"> \
                <div class="col-lg-3 col-md-4 col-sm-6"> \
                    <div class="ingredient_name">'+item.name+'</div> \
                </div> \
                <div class="col-lg-3 col-md-4 col-sm-6"> \
                    <input class="quantity" type="text" size="4"> \
                    <select class="unit"> \
                        <option></option> \
                        <option>g</option> \
                        <option>ml</option> \
                        <option>cups</option> \
                        <option>spoons</option> \
                        <option>table spoons</option> \
                        <option>pinches</option> \
                        <option>slices</option> \
                    </select> \
                </div> \
                <div class="col-lg-3 col-md-4 col-sm-6" style="margin-left: -3vw"> \
                    <input class="main_ingredient" type="checkbox"> \
                </div> \
                <div class="col-lg-3 col-md-4 col-sm-6" style="margin-left: -7vw"> \
                    <input class="seasoning" type="checkbox"> \
                </div> \
                <button class="roundbtn" onclick="removeRow(this)">remove</button> \
            </div>');
            map.set(item.name, item.id);
        }
        
        return false;
    },
    _focus: function(e, ui) {
        e.preventDefault();
    }
}