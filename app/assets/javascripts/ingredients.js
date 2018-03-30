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
        
        if (!map.has(item.name)) {
            $('#kitchen_list').append('<li onclick="removeFilter(this)">'+item.name+'</li>');
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
            $('#new_yori_ingredients').append('<div class="row" style="display: inline-flex; width: 90%" \
            id="'+item.name+'"> \
                <div class="col-lg-3 col-md-4 col-sm-6"> \
                    <input class="main_ingredient" type="checkbox"> \
                </div> \
                <div class="col-lg-3 col-md-4 col-sm-6" style="margin-left: -5vw"> \
                    <input class="seasoning" type="checkbox"> \
                </div> \
                <div class="col-lg-3 col-md-4 col-sm-6" style="margin-left: -2vw"> \
                    <div class="ingredient_name">'+item.name+'</div> \
                </div> \
                <div class="col-lg-3 col-md-4 col-sm-6"> \
                    <input class="quantity" type="text" size="6"> \
                    <select class="unit"> \
                        <option>g</option> \
                        <option>ml</option> \
                        <option>개</option> \
                        <option>큰술</option> \
                        <option>작은술</option> \
                        <option>컵</option> \
                        <option>꼬집</option> \
                    </select> \
                </div> \
                <button class="roundbtn" onclick="removeRow(this)">빼기</button> \
            </div>');
            map.set(item.name, item.id);
        }
        
        return false;
    },
    _focus: function(e, ui) {
        e.preventDefault();
    }
}