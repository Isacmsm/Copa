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