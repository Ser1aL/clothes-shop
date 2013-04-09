tinyMCE.init({
    mode: 'textareas',
    theme: 'advanced',
    editor_selector: "tiny_mce"
});
$(document).ready(function() {
    $('.new_article_form form, .edit_article_form').submit(function(){
        if($(this).find("input[id='title']").val() == ''){
            alert('Поле название не может быть пустым');
            return false;
        }
    });
});
