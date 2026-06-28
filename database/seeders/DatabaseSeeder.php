<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $usuarios = [
            [
                'correo' => 'admin@uniincubadora.edu.ec',
                'nombre' => 'Administrador',
                'clave'  => 'admin1234',
                'rol'    => 'administrador',
            ],
            [
                'correo' => 'mentor@uniincubadora.edu.ec',
                'nombre' => 'Carlos Mentor',
                'clave'  => 'mentor1234',
                'rol'    => 'mentor',
            ],
            [
                'correo' => 'estudiante@uniincubadora.edu.ec',
                'nombre' => 'Maria Emprendedora',
                'clave'  => 'estudiante1234',
                'rol'    => 'emprendedor',
            ],
        ];

        foreach ($usuarios as $u) {
            User::firstOrCreate(
                ['correo' => $u['correo']],
                [
                    'nombre'         => $u['nombre'],
                    'clave'          => Hash::make($u['clave']),
                    'rol'            => $u['rol'],
                    'estado'         => 'activo',
                    'fecha_registro' => now(),
                ]
            );
        }
    }
}
