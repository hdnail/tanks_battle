<?php

namespace Connector;

use Mongolid\Connection\Manager;
use Mongolid\Connection\Connection;


class NoSqlConnector {
    private Manager $manager;
    private static self|null $instance = null;

    public static function getInstance(): static {
        if (self::$instance === null) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    private function __construct() {}

    public function connect() {
        $this->manager = new Manager();
        $this->manager->setConnection(new Connection('mongodb://mongodb:27017'));
    }
}

/*
use Models\Post;
# MongoDB
$posts = Models\Post::all();
foreach($posts as $post) {
    print_r($post); exit;
}
// $post = new Models\Post(); $post->title = 'Foo bar pepe parada'; $post->save();
$post = Models\Post::first(['title' => 'Foo bar pepe parada']); print_r($post); exit;
*/