<?php

return [
    'paths'                    => ['api/*'],
    'allowed_methods'          => ['*'],
<<<<<<< HEAD
    'allowed_origins'          => array_filter([
        env('FRONTEND_URL', 'http://localhost:5173'),
        'http://localhost:5173',
        'http://localhost:5174',
    ]),
=======
    'allowed_origins'          => explode(',', env('ALLOWED_ORIGINS', '*' )),
>>>>>>> f19f637fe0187796c64592efa3a3edb8c3f27e5a
    'allowed_origins_patterns' => [],
    'allowed_headers'          => ['*'],
    'exposed_headers'          => [],
    'max_age'                  => 0,
    'supports_credentials'     => false,
];
