function estadoInicial() {
    var elements = document.querySelectorAll('input, select');
    if (elements) {
        elements.forEach(function (item) {
            var type = item.type;
            var tag = item.tagName.toLowerCase();

            if (type == 'text' || type == 'hidden' || type == 'password' || tag == 'textarea') {
                item.value = '';
            } else if (type == 'checkbox' || type == 'radio') {
                item.checked = false;
            } else if (tag == 'select') {
                item.selectedIndex = -1;
            }
        });
    }
}
function executaAcao(acao) {
    document.form1.acao.value = acao;
    document.form1.submit();
}

function setarTema() {


    var tema = sessionStorage.getItem('tema');

    if (tema) {

        if (tema == "") {
            labelTexto = "Tema Escuro";
        }
        else {
            labelTexto = "Tema Claro";
        }
        $("#tema").text(labelTexto);

        $(document.documentElement).attr("data-bs-theme", tema);
    }

}
function consultarSetarTema() {
    $.ajax({
        method: "POST",
        url: "/arearestrita/ConsultarSalvarTema.cshtml",
        data: {
            novoTema: '',
            acao: 'RT'
        }
    }).done(function (retorno) {

        if (tema == "") {
            labelTexto = "Tema Escuro";
            novoTema = '';
        }
        else {
            labelTexto = "Tema Claro";
            novoTema = 'dark';
        }

        //$(document.documentElement).attr("data-bs-theme", novoTema);

        sessionStorage.setItem('tema', retorno);

        alert(sessionStorage.setItem('tema'));


    });
}
function salvarTema(tema) {

    var labelTexto = '';
    var novoTema = '';

    if (tema == "Tema Claro") {
        labelTexto = "Tema Escuro";
        novoTema = '';
    }
    else {
        labelTexto = "Tema Claro";
        novoTema = 'dark';
    }

    $("#tema").text(labelTexto);
    $(document.documentElement).attr("data-bs-theme", novoTema);

    sessionStorage.setItem('tema', novoTema);

    $.ajax({
        method: "POST",
        url: "/arearestrita/ConsultarSalvarTema.cshtml",
        data: {
            novoTema: tema,
            acao: 'ST'
        }
    });
}