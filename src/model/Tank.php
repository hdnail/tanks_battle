<?php

namespace Model;

use Connector\NoSqlConnector;
use Mongolid\Model\AbstractModel;

class Tank extends AbstractModel {

    protected $collection = 'tanks';

    public function bsonSerialize(): object|array {
        return parent::bsonSerialize();
    }
}