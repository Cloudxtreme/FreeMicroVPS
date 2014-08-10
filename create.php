<?php 

function send($err,$msg)
{
    echo($_GET["callback"]."(".json_encode(array("err"=>$err, "msg"=>$msg)).");");
}

if(!isset($_GET["callback"]))
    die('{"err":1,"msg":"Invalid argument"}');

die(send(1, "Check back later"));

$msg = <<<HTML
<p>Your VPS was successfully created. You have three options to connect: tor, web, and ipv6.</p>
HTML;

send(0, $msg);

?>
