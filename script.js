// Formulário de contato: como o site é estático (sem servidor),
// a mensagem não é enviada de verdade. O script valida os campos
// e exibe uma confirmação para o usuário.
const formulario = document.getElementById("form-contato");
const aviso = document.getElementById("mensagem-sucesso");

formulario.addEventListener("submit", function (evento) {
    evento.preventDefault();          // impede o recarregamento da página
    aviso.style.display = "block";    // mostra a mensagem de sucesso
    formulario.reset();               // limpa os campos
});
