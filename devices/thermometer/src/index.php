<?php

    header("Content-Type: application/json");

    $token = "ZFLW-AZCR";

    $data = [];
    $code = 200;

    class Request {
        public $token = "ZFLW-AZCR";
        public $data = [];
        public $code = 200;

        function get() {
            if(!$this->validateToken()) {
                return;
            }

            $h = rand(50, 95);
            $t = rand(20, 35);
            $f = rand(60, 140);
            $hif = rand(40 ,50);
            $hic = rand(20, 40);

            $data = [
                "status" => true,
                "humidity" => $h,
               "temperature_c" => $t,
               "temperature_f" => $f,
               "heat_index_c" => $hic,
               "heat_index_f" => $hif,
            ];

            $this->reply($data, 200);
        }

        function handleNotFound() {
            $this->reply(["response" => "404"], 404);
        }

        function validateToken() {
            if(isset($_POST['token']) && $_POST['token'] != $this->token) {
                $this->reply([
                    "failed_validation" => "token"
                ], 422);
                return false;
            }
            return true;
        }

        function reply($data, $code) {
            print json_encode($data);
            http_response_code($code);
        }

    }

    $request = new Request();

    $action = "get";
    if(isset($_GET['action'])) {
        $action = $_GET['action'];
    }

    if($action == "get") {
        $request->get();
    } else {
        $request->handleNotFound();
    }

?>