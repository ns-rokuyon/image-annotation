"use strict";

$(function(){
    $(".set_label_link").on("click", function(e){
        var posturl = $(this).data('posturl');
        var label = $(this).data("postlabel");
        var imagepath = $("#tmpdata").data("imagepath");
        var a_btn_id = $("#tmpdata").data("index");
        $.ajax({
            type: "POST",
            url: posturl,
            dataType: "json",
            data: {
                "label": label,
                "imagepath": imagepath
            }
        }).done(function(res){
            $("#" + a_btn_id).html(res["label"]).removeClass("btn-default").addClass("btn-success");
            $('#label_modal_image').attr('src', '')
                .attr('data-imagepath', '').attr('data-index', '');
        }).fail(function(res){
            console.log(res);
        });
    });

    $("#label_remove_button").on("click", function(e){
        var posturl = $(this).data('posturl');
        var imagepath = $("#tmpdata").data("imagepath");
        var a_btn_id = $("#tmpdata").data("index");
        $.ajax({
            type: "POST",
            url: posturl,
            dataType: "json",
            data: {
                "imagepath": imagepath
            }
        }).done(function(res){
            $("#" + a_btn_id).html("no labeled").removeClass("btn-success").addClass("btn-default");
            $('#label_modal_image').attr('src', '')
                .attr('data-imagepath', '').attr('data-index', '');
        }).fail(function(res){
            console.log(res);
        });
    });

    $('#label_modal').on('show.bs.modal', function(e){
        var div_caption = e.relatedTarget.parentElement;
        var div_thumbbox = div_caption.parentElement;

        var imagepath = $(div_thumbbox).data('imagepath');
        var imageurl = div_thumbbox.firstElementChild.href;
        var a_btn_id = $(div_caption)[0].children[1].id;
        $('#label_modal_image').attr('src', imageurl);
        $('#tmpdata').data('imagepath', imagepath).data('index', a_btn_id);
    });
});
