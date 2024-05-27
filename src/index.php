<?php

use Phalcon\Http\Response;
use Phalcon\Mvc\Micro;

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