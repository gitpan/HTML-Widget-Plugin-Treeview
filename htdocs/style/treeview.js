function ocFolder(id){
    var  folder = document.getElementById(id).className;
    if(folder == 'folderOpen'){
        document.getElementById(id).className = 'folderClosed';
    }else if(folder == 'folderClosed'){
        document.getElementById(id).className = 'folderOpen';
    }else{
        var mclass = /(folder.*)Closed/;
        var isclosed = mclass.test(folder);
        if (isclosed == true){
            document.getElementById(id).className = mclass.replace(/(folder.*)Closed/, '$1');
        }else{
            document.getElementById(id).className = mclass.replace(/(folder.*)/, '$1Closed')
        }
    }
	
}
function ocNode(id){
var folder = document.getElementById(id).className;if(folder == "minusNode"){
document.getElementById(id).className = 'plusNode';
}else if(folder == "plusNode"){
document.getElementById(id).className = 'minusNode';
}
}
function ocpNode(id){
var folder = document.getElementById(id).className;
if(folder == "lastMinusNode"){
document.getElementById(id).className = 'lastPlusNode';
}else if(folder == "lastPlusNode"){
document.getElementById(id).className = 'lastMinusNode';
}
}
function displayTree(id){
var e = document.getElementById(id);
var display = e.style.display;
if(display == "none"){
e.style.display = "";
}else if(display == ""){
e.style.display = "none";
}
}