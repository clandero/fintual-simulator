console.log('Hello from My JS')
toggleSubmitBtn(false)
document.getElementById('loader').style.display = 'none'

var sliders = document.querySelectorAll("#conservative, #moderate, #risky");

for(i=0; i<sliders.length; ++i){
    document.getElementById(sliders[i].id+'_percentage').innerHTML = sliders[i].value + " %";
}

for(i=0; i<sliders.length; ++i){
    let item = document.getElementById(sliders[i].id)
    item.oninput = function(){
        updatePercentage(item)
        checkComposition()
    }
}


function updatePercentage(element){
    document.getElementById(element.id+'_percentage').innerHTML = element.value + " %";
}


function getPortfolioComposition(){
    return parseInt(document.getElementById('conservative').value) + parseInt(document.getElementById('moderate').value) + parseInt(document.getElementById('risky').value)
}


function checkComposition(){
    if(getPortfolioComposition() > 100){
        let sobrante = getPortfolioComposition()-100;
        document.getElementById('composition_error').innerHTML = 'Porcentajes exceden el 100%, por favor reduzca alguno de los fondos en ' + sobrante + ' %.'
        toggleSubmitBtn(false);
    }
    else if(getPortfolioComposition() < 100){
        let restante = 100-getPortfolioComposition();
        document.getElementById('composition_error').innerHTML = 'Porcentajes son inferior al 100%, por favor asigna el ' + restante + ' % restante en cualquiera de los fondos.'
        toggleSubmitBtn(false);
    }
    else{
        document.getElementById('composition_error').innerHTML = "";
        toggleSubmitBtn(true)
    }
}


function toggleSubmitBtn(value){
    document.getElementById('submit_btn').disabled = !value;
    if(value){
        document.getElementById('submit_btn').style.display = '';
    }else{
        document.getElementById('submit_btn').style.display = 'none';
    }
    
}


document.getElementById('submit_btn').onclick = function(){
    if(document.getElementById('monto_inicial').value != "" && document.getElementById('fecha_inicio').value != "" && document.getElementById('fecha_inicio').value >= "2018-02-13"){
        document.getElementById('loader').style.display = '';
    }
}