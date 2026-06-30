<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Migrar correos viejos @uniincubadora.edu.ec a @unesum.edu.ec
        User::where('correo', 'admin@uniincubadora.edu.ec')
            ->update(['correo' => 'admin@unesum.edu.ec']);
        User::where('correo', 'mentor@uniincubadora.edu.ec')
            ->update(['correo' => 'mentor@unesum.edu.ec']);
        User::where('correo', 'estudiante@uniincubadora.edu.ec')
            ->update(['correo' => 'estudiante@unesum.edu.ec']);

        $usuarios = [
            [
                'correo' => 'admin@unesum.edu.ec',
                'nombre' => 'Administrador',
                'clave'  => 'admin1234',
                'rol'    => 'administrador',
            ],
            [
                'correo' => 'mentor@unesum.edu.ec',
                'nombre' => 'Carlos Mentor',
                'clave'  => 'mentor1234',
                'rol'    => 'mentor',
            ],
            [
                'correo' => 'estudiante@unesum.edu.ec',
                'nombre' => 'Maria Emprendedora',
                'clave'  => 'estudiante1234',
                'rol'    => 'emprendedor',
            ],
        ];

        foreach ($usuarios as $u) {
            $user = User::where('correo', $u['correo'])->first();
            if ($user) {
                $user->update([
                    'clave'         => Hash::make($u['clave']),
                    'clave_visible' => $u['clave'],
                ]);
            } else {
                User::create([
                    'correo'         => $u['correo'],
                    'nombre'         => $u['nombre'],
                    'clave'          => Hash::make($u['clave']),
                    'clave_visible'  => $u['clave'],
                    'rol'            => $u['rol'],
                    'estado'         => 'activo',
                    'fecha_registro' => now(),
                ]);
            }
        }
    }
}
