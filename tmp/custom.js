// if footer is null it will be hidden, if undefined it will be a close button
function showModal(title, body, footer, size)
{
    $("#modal-template .modal-title").html(title);
    $("#modal-template .modal-body").html(body);
    
    // determine how to display the footer
    if(footer === null)
        $("#modal-template .modal-footer").hide();
    else
    {
        $("#modal-template .modal-footer").show();

        if(footer === undefined)
        {
            $("#modal-template .modal-footer-contents").hide();
            $("#modal-template .modal-footer button").show();
        }
        else
        {
            $("#modal-template .modal-footer-contents").show();
            $("#modal-template .modal-footer button").hide();
        }
    }

    switch(size)
    {
    case "sm":
    case "small":
        console.log("small modal");
        $("#modal-template .modal-dialog").removeClass("modal-lg");
        $("#modal-template .modal-dialog").addClass("modal-sm");
        break;
    case "lg":
    case "large":
        $("#modal-template .modal-dialog").removeClass("modal-sm");
        $("#modal-template .modal-dialog").addClass("modal-lg");
        break;
    default:
        $("#modal-template .modal-dialog").removeClass("modal-lg");
        $("#modal-template .modal-dialog").removeClass("modal-sm");
        break;
    }

    $("#modal-template").modal("show");
}

// misc js init
$(function(){
    // replace "hidden" class with hide() function so show() function works
    $(".hidden").hide().removeClass("hidden");

    // enable popovers and tooltips
    //$(".popover-dismiss").popover({trigger:"focus"});
    $(".tooltip-enable").tooltip();

    // disable html form submit so we can use ajax (html is used as a fallback if javascript is disabled)
    $("form").each(function(){
        $(this).after("<div class=\"form\">"+$(this).html()+"</div>");
        $(this).remove();
    });

    // show() elements with nohide class
    $(".js-unhide").show();

    // disable href attr for elements of nohref class (so a click js handler can be used instead)
    $(".js-nohref").attr("href", "javascript:void(0);");
});
    
// register click handlers
$(function(){
    $(".toggle-privacy-modal").click(function(){
        showModal("Privacy Policy", privacy_policy);
    });
    
    $(".toggle-tos-modal").click(function(){
        showModal("Web Site Terms and Conditions of Use", tos);
    });
    $(".toggle-anon-restrict-modal").click(function(){
        showModal("Anonymous Account Restrictions", anon_restrict);
    });
    $(".toggle-reg-restrict-modal").click(function(){
        showModal("Registered Account Restrictions", reg_restrict);
    });
    $(".toggle-supp-restrict-modal").click(function(){
        showModal("Supporter Account Restrictions", supp_restrict);
    });

    // "create anonymous account" buttons
    $(".create-anon-btn").click(function(){
        console.log("creating vps...");
        $.ajax({
            url: "http://ajax.freemicrovps.com/create.php",
            error: function(jqxhr, textStatus){
                console.log("ajax error: "+textStatus);
                showModal("Error", "Error contacting server, please try again later.");
            },
            dataType: "jsonp",
            type: "POST"
        }).done(function(data){
            if(data.err)
                showModal("Error", data.msg);
            else
                showModal("New VPS Created", data.msg);
            console.log("created account");
        },"json");
    });
});
