<?php
require_once __DIR__ . '/vendor/autoload.php';
//phpinfo(); exit;

const REDIS_STANDARD_EXPIRY = 3600 * 24;

$redis = new Redis();
// $ping = $redis->ping(); print_r($ping); exit;

$redis->connect('redis', 6379);
$dummyData = ["pepe"=> ["name"=>"john", "surname"=> "doe"], "id"=> 23];
# $redis->setex('pepe:1', REDIS_STANDARD_EXPIRY, json_encode($dummyData));

$data = $redis->get('pepe:1');
$data = json_decode($data, true);

print_r($dummyData);
print_r($data); exit;


use Phalcon\Http\Response;
use Phalcon\Mvc\Micro;

// use Models\Post;

# MongoDB
use Mongolid\Connection\Manager;
use Mongolid\Connection\Connection;
$manager = new Manager();
$manager->setConnection(new Connection('mongodb://mongodb:27017'));

/*
$posts = Models\Post::all();
foreach($posts as $post) {
    print_r($post); exit;
}
*/

// $post = new Models\Post(); $post->title = 'Foo bar pepe parada'; $post->save();
$post = Models\Post::first(['title' => 'Foo bar pepe parada']); print_r($post); exit;



exit;


$app = new Micro();

$app->get(
    '/api/robots/{id:[0-9]+}',
    function ($id) use ($app) {
        $response = new Response();
        $response->setJsonContent(
            [
                'status' => 'FOUNtatataD',
                'data'   => [
                    'id'   => 1,
                    'name' => "hola"
                ]
            ]
        );
        return $response;
    }
);

$app->handle($_SERVER["REQUEST_URI"]);