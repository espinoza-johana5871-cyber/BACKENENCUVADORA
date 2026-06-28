<?php

$origins = array_values(array_filter(array_unique(array_merge(
    array_map('trim', explode(',', env('ALLOWED_ORIGINS', ''))),
    [env('FRONTEND_URL', '')],
    ['http://localhost:5173', 'http://localhost:5174'],
))));

return [
    'paths'                    => ['api/*'],
    'allowed_methods'          => ['*'],
    'allowed_origins'          => $origins,
    'allowed_origins_patterns' => [],
    'allowed_headers'          => ['*'],
    'exposed_headers'          => [],
    'max_age'                  => 0,
    'supports_credentials'     => false,
];
