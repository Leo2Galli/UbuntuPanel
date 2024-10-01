<?php
session_start();
header('Content-Type: image/png');

$captcha_text = substr(str_shuffle("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"), 0, 6);
$_SESSION['captcha'] = $captcha_text;

$image = imagecreate(200, 50);
$bg = imagecolorallocate($image, 255, 255, 255);
$text_color = imagecolorallocate($image, 0, 0, 0);
imagestring($image, 5, 50, 15, $captcha_text, $text_color);
imagepng($image);
imagedestroy($image);
?>
