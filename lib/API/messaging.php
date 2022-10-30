<?php


define('API_ACCESS_KEY', 'BCUDdSazennrse86cQIuvkqPDL426xQ5MBeIoG2nK9xZP5EfzQQ6V3Ovt_OI7H3UK_ZoMVWFvZ_2DCF6ncAHXo0');

$fcmUrl = "https://fcm.googleapis.com/fcm/send";

$token = $_POST["token"];


$notification = [
    'title' => "Wordpress Notification",
    "body" => "Hello, world",
    "icon" => "myIcon",
    "sound" => "mySOund"
];

$extraNotificationData = ["message" => $notification, "moredata" => 'dd'];

$fcmNotification = [
    //'registration_ids' => $tokenList, //multple token array
    'to'        => $token, //single token
    'notification' => $notification,
    'data' => $extraNotificationData
];

$headers = [
    'Authorization: key=' . API_ACCESS_KEY,
    'Content-Type: application/json'
];


$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $fcmUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fcmNotification));
$result = curl_exec($ch);
curl_close($ch);


echo $result;
