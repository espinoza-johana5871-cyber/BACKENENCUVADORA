import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
<<<<<<< HEAD
=======
import react from '@vitejs/plugin-react';
>>>>>>> f19f637fe0187796c64592efa3a3edb8c3f27e5a
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
    plugins: [
<<<<<<< HEAD
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
=======
        react(),
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.jsx'],
>>>>>>> f19f637fe0187796c64592efa3a3edb8c3f27e5a
            refresh: true,
        }),
        tailwindcss(),
    ],
    server: {
        watch: {
            ignored: ['**/storage/framework/views/**'],
        },
    },
});
