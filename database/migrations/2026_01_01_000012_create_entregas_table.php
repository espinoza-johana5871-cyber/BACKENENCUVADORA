<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('entregas', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('proyecto_id');
            $table->unsignedInteger('usuario_id');
            $table->text('descripcion');
            $table->string('archivo_nombre', 500)->nullable();
            $table->string('archivo_path', 500)->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('proyecto_id', 'fk_entregas_proyecto')
                  ->references('id_proyecto')->on('proyectos')
                  ->onDelete('cascade');

            $table->foreign('usuario_id', 'fk_entregas_usuario')
                  ->references('id_usuario')->on('usuarios')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('entregas');
    }
};
