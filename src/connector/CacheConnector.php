<?php

namespace Connector;

use Redis;

class CacheConnector {
    private $redis;
    private static self|null $instance = null;
    private const REDIS_STANDARD_EXPIRY = 86400;

    private function __construct() {
        $this->redis = new Redis();
        $this->redis->connect('redis', 6379);
    }

    public static function getInstance(): static {
        if (self::$instance === null) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    public function set($key, $value) : void {
        $this->redis->setex($key, self::REDIS_STANDARD_EXPIRY, $value);
    }

    public function get($key, $value) {
        return $this->redis->get($key);
    }
}

/*
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
*/