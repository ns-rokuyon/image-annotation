"use strict";

var jcrop_api;
var post_region_func;
var update_modal_button_func;
var update_region_list_func;

function registerRegion(coords){
    var imagepath = $("#tmpdata").data("imagepath");
    var posturl = $('#tmpdata').data('posturl');
    var select_region_id = $('input[name="region_selector"]:checked').val();

    post_region_func = function register(){
        $.ajax({
            type: "POST",
            url: posturl,
            dataType: "json",
            data: {
                "imagepath": imagepath,
                "region_index": select_region_id,
                "x": coords.x,
                "y": coords.y,
                "width": coords.w,
                "height": coords.h
            }
        }).done(function(res){
            app.annodata = res;
            if ( update_modal_button_func ) {
                update_modal_button_func(app.annodata);
            }
            if ( update_region_list_func ) {
                update_region_list_func();
            }
        }).fail(function(res){
            console.log(res);
        });
        jcrop_api.release();
        post_region_func = null;
    }
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

        update_modal_button_func = function(new_annodata){
            var num = new_annodata[imagepath].length;
            $('#' + a_btn_id).html("" + num + " regions");
            console.log(num);
            console.log(a_btn_id);
            update_modal_button_func = null;
        }

        $('#region_modal_image').attr('src', imageurl).Jcrop({
            onSelect: registerRegion,
            keySupport: false
        }, function(){
            jcrop_api = this;    
        }); 

        // region list
        update_region_list_func = function(){
            var i = 0;
            var parent_div = $('#region_modal_regions').html("");
            var div;
            if ( app.annodata[imagepath] ) {
                for ( ; i < app.annodata[imagepath].length; i++ ) {
                    div = $('<div>').addClass('form-group').addClass("has-primary");
                    var region = app.annodata[imagepath][i];
                    var region_info = " x:" + region["x"]
                        + ", y:" + region["y"]
                        + ", width:" + region["width"]
                        + ", height:" + region["height"];
                    div.append($('<label>').addClass('region_select_button').addClass("form-control")
                                .append($('<input>').attr('type', 'radio').attr('name', 'region_selector').attr('value',i))
                                .append($('<span>').addClass('region_info').html(region_info)));
                    parent_div.append(div);
                }
            }
            div = $('<div>').addClass('form-group').addClass("has-success");
            div.append($('<label>').addClass('region_select_button').addClass("form-control")
                        .append($('<input>').attr('type', 'radio').attr('name', 'region_selector').attr('value',i).attr('checked','checked'))
                        .append(" add new region"));

            parent_div.append(div);
        }
        update_region_list_func();

        $('#tmpdata').data('imagepath', imagepath);
    });

    $('#region_modal').on('hide.bs.modal', function(e){
        // clear Jcrop for #region_modal_image
        $('#region_modal_image').data('Jcrop').destroy();
    });

    // Select region from region info user selected
    $(document).on("click", ".region_select_button", function(e){
        try {
            $(this).parent().prevAll().removeClass("has-success").addClass("has-primary");
            $(this).parent().nextAll().removeClass("has-success").addClass("has-primary");
            $(this).parent().removeClass("has-primary").addClass("has-success");
            var region_info = $(this).children('.region_info').html();
            var arr = region_info.split(',');
            var x = parseInt(arr[0].split(':')[1]);
            var y = parseInt(arr[1].split(':')[1]);
            var width = parseInt(arr[2].split(':')[1]);
            var height = parseInt(arr[3].split(':')[1]);
            var x2 = x + width;
            var y2 = y + height;

            jcrop_api.setSelect([x,y,x2,y2])
        } catch (e) {
            // add new region button is selected
            jcrop_api.release();
        }
    });

    $('#region_modal_register_button').on('click', function(e){
        if ( post_region_func ) {
            post_region_func();
        }
    });

});

