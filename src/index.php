<?php
require_once __DIR__ . '/vendor/autoload.php';

use Phalcon\Http\Response;
use Phalcon\Mvc\Micro;

use Connector\NoSqlConnector;
use Model\Tank;

$db = NoSqlConnector::getInstance();
$db->connect();

$app = new Micro();
$app->post('/api/v1/tank', function() use ($app) {
    $body = $app->request->getJsonRawBody();
    $tank = new Tank();
    $tank->speed = $body->speed;
    $tank->turretRange = $body->turretRange;
    $tank->healthPoints = $body->healthPoints;
    $tank->save();
    $response = new Response();
    $response->setJsonContent(
        [
            'id' => (string)$tank->_id,
        ]
    );
    return $response;
});

// 66558c6c27db3e3b7d085e95
$app->get('/api/v1/tank/{id:[a-z0-9]+}', function($id) use ($app) {
    $tank = Tank::first($id);
    $response = new Response();
    $response->setJsonContent(
        [
            'id' => (string)$tank->_id,
            'speed' => $tank->speed,
            'turretRange' => $tank->turretRange,
            'healthPoints' => $tank->healthPoints
        ]
    );
    return $response;
});


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