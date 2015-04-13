<?php

Class HookHelper
{
    public $secret_key = 'THISISNOTSOSECRET';

    public function parseRequestHeaders()
    {
        $headers = array();
        foreach($_SERVER as $key => $value) {
            if (substr($key, 0, 5) <> 'HTTP_') {
                continue;
            }
            $header = str_replace(' ', '-', ucwords(str_replace('_', ' ', strtolower(substr($key, 5)))));
            $headers[$header] = $value;
        }

        return $headers;
    }

    public function parseRequestBody()
    {
        $body = file_get_contents('php://input');
        $body = json_decode($body, TRUE);

        return $body;
    }

    public function writeDataToFile($headers, $body)
    {
        $file = 'hook.log';
        file_put_contents($file, "\n\n===========\n", FILE_APPEND);
        file_put_contents($file, json_encode($headers), FILE_APPEND);
        file_put_contents($file, "\n\n", FILE_APPEND);
        file_put_contents($file, json_encode($body), FILE_APPEND);
    }

    public function verifySignature()
    {
        $headers = $this->parseRequestHeaders();
        $body = file_get_contents('php://input');

        $signature = 'sha1=' . hash_hmac('sha1', $body, $this->secret_key);
        if ($signature == $headers['X-Hub-Signature']) {
            return true;
        } else {
            return false;
        }
    }

    public function run()
    {
        $headers = $this->parseRequestHeaders();
        $body = $this->parseRequestBody();

        $this->writeDataToFile($headers, $body);

        if ($this->verifySignature()) {
            if ($headers['X-Github-Event'] == 'push') {
                if (!empty($body['ref'])) {
                    $explodeRef = explode('/', $body['ref']);
                    $type = $explodeRef[1];
                    $tags = $explodeRef[count($explodeRef)-1];

                    $repository = $body['repository']['name'];
                    if ($repository == 'api-todo' && $type == 'tags') {
                        echo shell_exec("sh deploy.sh $tags");
                    } else {
                        echo "Not Integrating Tags";
                    }
                }
            } else {
                echo "Not doing anything with event: " . $headers['X-Github-Event'];
            }
        } else {
            echo "Token doesn't match";
        }
    }
}

$hookHelper = new HookHelper();

$hookHelper->run();
