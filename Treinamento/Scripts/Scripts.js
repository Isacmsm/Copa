//função utilizada pelo botão limpar. O botão limpar é uma ação que está presente em todas as telas, e serve para limpar o formulario e voltar
//para o estado inicial da tela. Ele foi colocado no script pois é uma fnção utilizada em varias telas.
function estadoInicial() {
    var elements = document.querySelectorAll('select, input');
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

function executarAcao(acao) {
    document.form1.acao.value = acao;
    document.form1.submit();
}