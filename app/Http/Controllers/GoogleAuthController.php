<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Mentor;
use App\Models\Notificacion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Socialite\Facades\Socialite;

class GoogleAuthController extends Controller
{
    /**
     * Redirect al login de Google.
     */
    public function redirect()
    {
        return Socialite::driver('google')->redirect();
    }

    /**
     * Callback de Google. Recibe el código de autorización.
     * Pero como nuestro frontend es SPA, usamos el endpoint de token en su lugar.
     */
    public function callback()
    {
        try {
            $googleUser = Socialite::driver('google')->user();
            return $this->findOrCreateUser($googleUser);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error al autenticar con Google.'], 401);
        }
    }

    /**
     * Login con token de Google (para SPA frontend).
     * El frontend envía el id_token de Google y lo validamos.
     */
    public function loginWithToken(Request $request)
    {
        $request->validate([
            'token' => 'required|string',
        ]);

        try {
            $googleUser = Socialite::driver('google')->stateless()->userFromToken($request->token);
            return $this->findOrCreateUser($googleUser);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Token de Google inválido o expirado.',
                'debug' => config('app.debug') ? $e->getMessage() : null,
            ], 401);
        }
    }

    /**
     * Busca o crea el usuario basado en los datos de Google.
     */
    private function findOrCreateUser($googleUser)
    {
        $correo = $googleUser->getEmail();
        $nombre = $googleUser->getName() ?? $googleUser->getNickname() ?? explode('@', $correo)[0];

        // Verificar que el correo sea institucional UNESUM
        $allowedDomains = ['unesum.edu.ec'];
        $domain = explode('@', $correo)[1] ?? '';

        if (!in_array($domain, $allowedDomains)) {
            return response()->json([
                'message' => 'Solo se permiten correos institucionales UNESUM (@unesum.edu.ec).',
            ], 403);
        }

        // Buscar usuario existente
        $user = User::where('correo', $correo)->first();

        if ($user) {
            // Actualizar google_id si no lo tiene
            if (!$user->google_id) {
                $user->google_id = $googleUser->getId();
                $user->save();
            }
        } else {
            // Crear nuevo usuario como emprendedor por defecto
            $user = User::create([
                'nombre'         => $nombre,
                'correo'         => $correo,
                'clave'          => Hash::make(uniqid('google_', true)),
                'clave_visible'  => '(Google OAuth)',
                'google_id'      => $googleUser->getId(),
                'rol'            => 'emprendedor',
                'estado'         => 'activo',
                'fecha_registro' => now(),
            ]);

            // Notificar a los admins
            $admins = User::where('rol', 'administrador')->pluck('id_usuario');
            foreach ($admins as $adminId) {
                Notificacion::create([
                    'id_usuario' => $adminId,
                    'tipo'       => 'nuevo_usuario',
                    'mensaje'    => "Nuevo usuario registrado vía Google: \"{$user->nombre}\" ({$user->correo}).",
                    'url'        => '/admin/usuarios',
                ]);
            }
        }

        $token = $user->createToken('google-token')->plainTextToken;

        return response()->json([
            'user'  => [
                'id_usuario'    => $user->id_usuario,
                'nombre'        => $user->nombre,
                'correo'        => $user->correo,
                'rol'           => $user->rol,
                'estado'        => $user->estado,
                'fecha_registro'=> $user->fecha_registro,
            ],
            'token' => $token,
        ]);
    }
}
