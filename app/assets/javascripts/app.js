var app = window.app = {};
var map = new Map();

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
    $("#steps").append('<div id='+step+', class="step"><div class="step_num">STEP '+step+'</div> \
                        [사진] <textarea class="bar" id="step'+step+'" rows="5" cols="50"></textarea> \
                        <button class="roundbtn" onclick="removeStep(this)">삭제</button> \
                        </div><br>');
                        
}

function removeStep(button) {
    var target = button.closest('div');
    target.remove();
    
    var start = parseInt(target.id)+1;
    for (i = start; i <= step; i++) {
        var newNum = i-1;
        $('#'+i).children()[0].innerHTML = "STEP "+newNum;
        $('#'+i).children()[1].id = "step"+newNum;
        $('#'+i)[0].id = newNum;
    }
    
    step--;
}

function back() {
    window.history.back();
}