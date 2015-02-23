"use strict";

function registerRegion(coords){
    console.log(coords.x);
    console.log(coords.y);
    console.log(coords.w);
    console.log(coords.h);
    var imagepath = $("#tmpdata").data("imagepath");
    var posturl = $('#tmpdata').data('posturl');
    $.ajax({
        type: "POST",
        url: posturl,
        dataType: "json",
        data: {
            "imagepath": imagepath,
            "x": coords.x,
            "y": coords.y,
            "width": coords.w,
            "height": coords.h
        }
    }).done(function(res){
        console.log(res);
        $('#region_modal_regiondata').html("x : " + res['x']);
    }).fail(function(res){
        console.log(res);
    });
}

$(function(){
    $(".set_region_link").on("click", function(e){
        var posturl = $(this).data('posturl');
        var label = $(this).data("postregion");
        var imagepath = $("#tmpdata").data("imagepath");
    });

    $('#region_modal').on('show.bs.modal', function(e){
        var div_caption = e.relatedTarget.parentElement;
        var div_thumbbox = div_caption.parentElement;

        var imagepath = $(div_thumbbox).data('imagepath');
        var imageurl = div_thumbbox.firstElementChild.href;
        var a_btn_id = $(div_caption)[0].children[1].id;
        $('#region_modal_image').attr('src', imageurl).Jcrop({
            onSelect: registerRegion,
            keySupport: false
        }); 
        $('#tmpdata').data('imagepath', imagepath);
    });

    $('#region_modal').on('hide.bs.modal', function(e){
        // clear Jcrop for #region_modal_image
        $('#region_modal_image').data('Jcrop').destroy();
    });

});

