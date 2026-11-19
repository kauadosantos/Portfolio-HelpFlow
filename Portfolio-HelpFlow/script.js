
const formulario = document.getElementById("form-contato");
const aviso = document.getElementById("mensagem-sucesso");

formulario.addEventListener("submit", function (evento) {
    evento.preventDefault();          
    aviso.style.display = "block";    
    formulario.reset();               
});
