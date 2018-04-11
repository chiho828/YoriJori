var app = window.app = {};
var map = new Map();

//
// var myFormData = new FormData();
//

function guestWarning() {
    alert("Please log in to use this feature!");
}

function removeFilter(span) {
    var name = span.innerHTML;
    console.log(name);
    map.delete(name);
    console.log(map)
    span.remove();
}

function removeRow(button) {
    var row = button.closest('div');
    map.delete(row.id);
    row.remove();
}

function addStep() {
    step++;
    $("#steps").append('<div id='+step+'><div class="step_num">STEP '+step+'</div> \
                        [사진] <textarea class="bar" id="step'+step+'" rows="5" cols="50"></textarea> \
                        <button class="roundbtn" onclick="addMiddleStep(this)">추가</button> \
                        <button class="roundbtn" onclick="removeStep(this)">삭제</button> \
                        </div>');
                        
}

function addMiddleStep(button) {
    step++;
    
    var index = parseInt(button.parentElement.id)+1;
    for (var i = step-1; i >= index; i--) {
        var current = $("#"+i)[0];
        current.children[0].innerHTML = "STEP "+(i+1);
        $("#"+i)[0].id = i+1;
    }

    var template = document.createElement('template');
    var html = '<div id='+index+'><div class="step_num">STEP '+index+'</div> \
                    [image] <textarea class="bar" id="step'+index+'" rows="5" cols="50"></textarea> \
                    <button class="roundbtn" onclick="addMiddleStep(this)">add</button> \
                    <button class="roundbtn" onclick="removeStep(this)">remove</button> \
                    </div>'.trim();
    template.innerHTML = html;
    
    var mid = template.content.children[0];
    var next = $("#"+(index+1))[0];
    $("#steps")[0].insertBefore(mid, next);
}

function removeStep(button) {
    var target = button.closest('div');
    
    var start = parseInt(target.id)+1;
    for (i = start; i <= step; i++) {
        var newNum = i-1;
        $('#'+i)[0].children[0].innerHTML = "STEP "+newNum;
        $('#'+i)[0].children[1].id = "step"+newNum;
        $('#'+i)[0].id = newNum;
    }
    
    target.remove();
    step--;
}

function back() {
    window.history.back();
}