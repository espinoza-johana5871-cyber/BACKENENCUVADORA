<?php

return [
    'paths'                    => ['api/*'],
    'allowed_methods'          => ['*'],
    'allowed_origins'          => array_values(array_filter(array_unique(array_merge(
        // Orígenes desde variable de entorno (separados por coma)
        explode(',', env('ALLOWED_ORIGINS', '')),
        // Frontend URL explícito
        [env('FRONTEND_URL', '')],
        // Locales por defecto
        ['http://localhost:5173', 'http://localhost:5174'],
    ]))),
    'allowed_origins_patterns' => [],
    'allowed_headers'          => ['*'],
    'exposed_headers'          => [],
    'max_age'                  => 0,
    'supports_credentials'     => false,
];
